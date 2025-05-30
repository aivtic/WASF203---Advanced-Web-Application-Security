

### **Lab 12: Insufficient Logging and Monitoring - Advanced Detection Techniques**

#### **Objective:**
In this lab, you will:
1. Learn how to implement advanced detection techniques for identifying security breaches through logs.
2. Use log analysis tools to detect anomalies and unusual behavior.
3. Implement mechanisms for real-time alerts based on suspicious activities.

---

### **Task 1: Enhance Logging Mechanisms**

#### **Step 1: Introduce More Detailed Logging**

1. **Add Detailed Logging**: In your `login.php` page, update the logging functionality to capture more detailed information about each login attempt. For example:
   - Log the time of the attempt.
   - Log the IP address and user-agent for each attempt.
   - Log the status of the login attempt (successful/failed).

   Update the code as follows:

   ```php
   <?php
   session_start();
   $log_file = __DIR__ . '/access.log'; // __DIR__ returns the current directory

   // Hardcoded credentials
   $username = "admin";
   $password = "password123";

   if ($_SERVER['REQUEST_METHOD'] == 'POST') {
       $input_user = $_POST['username'];
       $input_pass = $_POST['password'];
       $ip_address = $_SERVER['REMOTE_ADDR'];
       $user_agent = $_SERVER['HTTP_USER_AGENT'];

       // Log all login attempts (both success and failure)
       $status = ($input_user === $username && $input_pass === $password) ? 'SUCCESS' : 'FAILURE';
       $log_message = "[" . date("Y-m-d H:i:s") . "] Login attempt by $input_user from IP: $ip_address, User-Agent: $user_agent, Status: $status\n";
       file_put_contents($log_file, $log_message, FILE_APPEND);

       if ($status == 'SUCCESS') {
           $_SESSION['user'] = $input_user;
           echo "<h1>Login Successful!</h1>";
       } else {
           echo "<h1>Invalid Credentials!</h1>";
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

#### **Step 2: Check the Logs**

1. After testing successful and failed login attempts, open the `access.log` file.
2. Verify that it contains detailed information for each login attempt, including:
   - Timestamp
   - Username
   - IP Address
   - User-Agent
   - Status (SUCCESS/FAILURE)

Example log entry:

```txt
[2024-12-21 15:00:01] Login attempt by admin from IP: 192.168.1.1, User-Agent: Mozilla/5.0, Status: SUCCESS
[2024-12-21 15:05:01] Login attempt by admin from IP: 192.168.1.1, User-Agent: Mozilla/5.0, Status: FAILURE
```

**Reflection Questions**:
- What information was added to the logs to enhance detection capabilities?
- How do these additional details help detect suspicious activities?

---

### **Deliverables**

For this assignment, submit the following:

1. **`index.php`** – The page simulating user access with enhanced logging.
2. **`login.php`** – The page for login attempts, with detailed logging and alert system.
3. **`access.log`** – Log file containing detailed login attempt records.
4. **`README.md`** – A brief explanation of:
   - How you implemented detailed logging.
   - The tools you used for log monitoring and alerting.
   - How real-time alerting improves incident detection.

---

### **Summary**

In this lab, you:
- Enhanced logging mechanisms to capture detailed information about login attempts.


