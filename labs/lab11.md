
### **Lab 11: Insufficient Logging and Monitoring**

#### **Objective:**
In this lab, you will:
1. Learn about the importance of logging and monitoring for detecting security incidents.
2. Implement logging mechanisms to record user activity and potential security events.
3. Explore how to detect and respond to suspicious activities through logs.

---

### **Task 1: Implement Logging in a Web Application**

#### **Step 1: Set Up the Web Application**

1. **Create a new folder** for the logging lab, e.g., `Lab12_Logging`.
2. Inside the folder, create the following files:
   - `index.php` (a page simulating a user interaction where actions are logged)
   - `login.php` (a page simulating user login)

3. **index.php**: This page will allow a user to simulate logging into the web application. You will log login attempts, including both successful and failed login attempts.

   ```php
   <?php
session_start();

// Define the log file path relative to the script's directory
$log_file = __DIR__ . '/access.log'; // __DIR__ returns the current directory

// Check if the user is logged in (simulating a login system)
if (isset($_SESSION['user'])) {
    echo "<h1>Welcome, " . $_SESSION['user'] . "!</h1>";
} else {
    echo "<h1>Please log in</h1>";
    echo '<a href="login.php">Login</a>';
}

// Log every access attempt
$log_message = "[" . date("Y-m-d H:i:s") . "] Access attempt from " . $_SERVER['REMOTE_ADDR'] . "\n";
file_put_contents($log_file, $log_message, FILE_APPEND);
?>

   ```

4. **login.php**: This page simulates a login form. We'll log login attempts, whether they are successful or failed.

   ```php
   <?php
session_start();

// Define the log file path relative to the script's directory
$log_file = __DIR__ . '/access.log'; // __DIR__ returns the current directory

// Hardcoded user credentials
$username = "admin";
$password = "password123";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input_user = $_POST['username'];
    $input_pass = $_POST['password'];

    if ($input_user === $username && $input_pass === $password) {
        $_SESSION['user'] = $input_user;
        echo "<h1>Login Successful!</h1>";
    } else {
        echo "<h1>Invalid Credentials!</h1>";
    }

    // Log login attempts (both success and failure)
    $log_message = "[" . date("Y-m-d H:i:s") . "] Login attempt by $input_user from " . $_SERVER['REMOTE_ADDR'] . "\n";
    file_put_contents($log_file, $log_message, FILE_APPEND);
}
?>

<form method="POST">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required><br>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required><br>
    <button type="submit">Login</button>
</form>

   ```

#### **Step 2: Test the Logging Functionality**

1. **Test the login functionality**: Access the `login.php` page and enter the following:
   - Correct credentials (`admin` / `password123`) to simulate a successful login.
   - Incorrect credentials to simulate a failed login attempt.

2. **Check the logs**: After testing, open the `access.log` file to view the logs. You should see entries that record the login attempts, including the username, timestamp, and IP address.

**Reflection Questions**:
- What information was recorded in the logs for each login attempt?
- How does logging help in detecting and monitoring suspicious activities?

---

### **Task 2: Implement Monitoring for Suspicious Activities**

#### **Step 1: Add Monitoring for Failed Logins**

1. **Modify the `login.php` page** to monitor failed login attempts by counting them and logging an alert if there are multiple failed attempts within a short time period (e.g., 3 failed attempts within 5 minutes).

   Add the following code to track failed login attempts:

   ```php
   <?php
session_start();

// Define log file and failed attempts file paths
$log_file = __DIR__ . '/access.log';
$failed_attempts_file = __DIR__ . '/failed_attempts.txt';

// Set the max number of failed attempts and the time limit (5 minutes)
$max_failed_attempts = 3;
$time_limit = 300; // 5 minutes

// Check if there are any failed login attempts recorded
if (file_exists($failed_attempts_file)) {
    $failed_attempts = json_decode(file_get_contents($failed_attempts_file), true);
} else {
    $failed_attempts = [];
}

// Check if the user is locked out
if (isset($failed_attempts['count']) && $failed_attempts['count'] >= $max_failed_attempts) {
    $last_failed_time = $failed_attempts['last_attempt_time'];
    if (time() - $last_failed_time < $time_limit) {
        echo "<h1>Too many failed attempts. Please try again later.</h1>";
        exit;
    } else {
        // Reset failed attempts if the lockout time has passed
        $failed_attempts['count'] = 0;
        file_put_contents($failed_attempts_file, json_encode($failed_attempts));
    }
}

// Hardcoded user credentials
$username = "admin";
$password = "password123";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input_user = $_POST['username'];
    $input_pass = $_POST['password'];

    if ($input_user === $username && $input_pass === $password) {
        $_SESSION['user'] = $input_user;
        echo "<h1>Login Successful!</h1>";
    } else {
        echo "<h1>Invalid Credentials!</h1>";

        // Track failed login attempts
        if (!isset($failed_attempts['count'])) {
            $failed_attempts['count'] = 0;
        }

        $failed_attempts['count']++;
        $failed_attempts['last_attempt_time'] = time();

        // Log the failed attempt
        $log_message = "[" . date("Y-m-d H:i:s") . "] Failed login attempt by $input_user from " . $_SERVER['REMOTE_ADDR'] . "\n";
        file_put_contents($log_file, $log_message, FILE_APPEND);
        file_put_contents($failed_attempts_file, json_encode($failed_attempts));

        if ($failed_attempts['count'] >= $max_failed_attempts) {
            $log_message = "[" . date("Y-m-d H:i:s") . "] ALERT: Suspicious activity detected. Too many failed login attempts from " . $_SERVER['REMOTE_ADDR'] . "\n";
            file_put_contents($log_file, $log_message, FILE_APPEND);
        }
    }
}
?>

<form method="POST">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required><br>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required><br>
    <button type="submit">Login</button>
</form>

   ```

#### **Step 2: Test the Monitoring**

1. **Test failed login attempts**: Try logging in with incorrect credentials multiple times (e.g., 3 times). After the 3rd failed attempt, you should be locked out and receive a message saying "Too many failed attempts. Please try again later."

2. **Check the logs**: Open the `access.log` file to verify that an alert has been logged after multiple failed login attempts. You should see an entry like:

   ```txt
   [2024-12-21 14:30:45] ALERT: Suspicious activity detected. Too many failed login attempts from 192.168.1.100
   ```

**Reflection Questions**:
- How did monitoring for failed login attempts improve the detection of suspicious activity?
- Why is it important to have a mechanism for locking out users after multiple failed login attempts?

---

### **Deliverables**

For this assignment, submit the following files:

1. **`index.php`** – The page that simulates user access and logging.
2. **`login.php`** – The page that simulates user login and tracks login attempts.
3. **`access.log`** – The log file containing user access and login attempt records.
4. **`failed_attempts.txt`** – The file that tracks failed login attempts.
5. **`README.md`** – A brief explanation document that includes:
   - A description of the logging and monitoring mechanisms implemented.
   - How you tracked and monitored failed login attempts.
   - Your thoughts on the importance of logging and monitoring in preventing attacks.

---

### **Summary**

In this lab, you:
- Learned the importance of logging and monitoring in detecting and responding to security incidents.
- Implemented logging for user access and login attempts.
- Monitored failed login attempts and added alerts for suspicious activities.

### **Reflection**

Proper logging and monitoring are critical for identifying and responding to security incidents. By logging activities such as login attempts and monitoring for suspicious patterns, you can detect potential attacks and take appropriate action to mitigate them.

---

Let me know when you're ready to proceed to the next topic or if you need any further assistance!