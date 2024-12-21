
### **Lab 18: Insufficient Logging & Monitoring**

#### **Objective:**
In this lab, you will:
1. Understand the importance of logging and monitoring in identifying and mitigating security incidents.
2. Explore an application with insufficient logging and demonstrate the impact of this vulnerability.
3. Implement logging and monitoring mechanisms to improve security and response time.

---

### **Task 1: Simulate Insufficient Logging & Monitoring**

#### **Step 1: Create a Vulnerable PHP Application**

1. Create a new folder for this lab, for example, `Lab18_Logging_Monitoring`.
2. Inside this folder, create a file called `login.php` where we simulate an application that does not log failed login attempts.

Example `login.php`:

```php
<?php
session_start();

$users = [
    'admin' => 'password123',
    'user1' => 'password456'
];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    if (isset($users[$username]) && $users[$username] === $password) {
        $_SESSION['username'] = $username;
        echo "<h1>Welcome, " . $username . "!</h1>";
    } else {
        echo "<h1>Invalid credentials!</h1>";
        // No logging of failed attempts here
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

In this vulnerable version, the application does not log failed login attempts. This makes it difficult for the administrator to detect brute force attacks or other malicious behavior.

#### **Step 2: Simulate an Attack**

1. Try several failed login attempts (using incorrect usernames or passwords).
2. Notice that the application does not record any information about these failed attempts.

If an attacker were to perform multiple failed login attempts in rapid succession, the application would not have any logs to indicate suspicious activity.

---

### **Task 2: Implement Proper Logging & Monitoring**

#### **Step 1: Add Logging to Failed Login Attempts**

We will use PHP's built-in `error_log` function to log failed login attempts.

Example `login.php` (with logging):

```php
<?php
session_start();

$users = [
    'admin' => 'password123',
    'user1' => 'password456'
];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    if (isset($users[$username]) && $users[$username] === $password) {
        $_SESSION['username'] = $username;
        echo "<h1>Welcome, " . $username . "!</h1>";
    } else {
        echo "<h1>Invalid credentials!</h1>";
        // Log failed login attempt
        error_log("Failed login attempt for username: $username from IP: " . $_SERVER['REMOTE_ADDR']);
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

In this updated version, every failed login attempt will be logged to the PHP error log file. The log will include the username used and the IP address of the user attempting to log in.

#### **Step 2: Monitor the Logs**

1. To test the logging mechanism, submit several incorrect login attempts.
2. Check the PHP error logs (usually located in `/var/log/apache2/error.log` or a similar directory depending on your server configuration).
   - You should see log entries like:  
     `Failed login attempt for username: admin from IP: 192.168.0.100`

#### **Step 3: Add Alerting for Suspicious Activity**

While logging is helpful, it's even better to monitor for suspicious activities such as repeated failed login attempts. For this, you can set up a basic threshold for failed login attempts and trigger an alert.

Example (add alert for multiple failed attempts):

```php
<?php
session_start();

$users = [
    'admin' => 'password123',
    'user1' => 'password456'
];

// Track failed attempts in session
if (!isset($_SESSION['failed_attempts'])) {
    $_SESSION['failed_attempts'] = 0;
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    if (isset($users[$username]) && $users[$username] === $password) {
        $_SESSION['username'] = $username;
        echo "<h1>Welcome, " . $username . "!</h1>";
        $_SESSION['failed_attempts'] = 0; // Reset on successful login
    } else {
        echo "<h1>Invalid credentials!</h1>";
        // Log failed login attempt
        error_log("Failed login attempt for username: $username from IP: " . $_SERVER['REMOTE_ADDR']);
        
        $_SESSION['failed_attempts']++;

        // Trigger alert if more than 3 failed attempts
        if ($_SESSION['failed_attempts'] > 3) {
            // In a real application, you could send an email or trigger other alerting mechanisms
            error_log("ALERT: Multiple failed login attempts detected from IP: " . $_SERVER['REMOTE_ADDR']);
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

Now, if a user fails to log in more than three times in a row, the application logs an **ALERT** to the error log, indicating possible brute-force activity.

---

### **Task 3: Test the Logging and Monitoring Mechanism**

1. **Test Failed Logins**: Submit a few failed login attempts and check the PHP error logs. You should see entries like:
   - `Failed login attempt for username: admin from IP: 192.168.0.100`
   - `ALERT: Multiple failed login attempts detected from IP: 192.168.0.100`

2. **Test Successful Logins**: After a successful login, check the logs to ensure that no unnecessary logs are generated for successful logins.

---

### **Reflection Questions:**

1. **Why is it important to log failed login attempts and other suspicious activities?**
2. **What impact could insufficient logging and monitoring have on your application’s security?**
3. **What measures did you implement to improve the application’s security regarding logging and monitoring?**

---

### **Deliverables:**

For this assignment, submit the following:

1. **`login.php`** – The original file without logging.
2. **`login.php`** – The updated file with proper logging and monitoring mechanisms.
3. **`README.md`** – A brief explanation of:
   - The importance of logging and monitoring.
   - The changes made to implement logging and alerting for suspicious activities.
   - How you tested the logging and monitoring mechanism.

---

### **Summary**

In this lab, you:
- Learned about the significance of logging and monitoring in identifying security issues.
- Identified and simulated a scenario with insufficient logging.
- Implemented logging of failed login attempts and set up basic monitoring and alerting for suspicious activities.

---

Let me know if you're ready for the next lab or if you need further details!