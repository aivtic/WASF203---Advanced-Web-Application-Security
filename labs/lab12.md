

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

### **Task 2: Implement Real-Time Alert System**

#### **Step 1: Install a Log Monitoring Tool**

For advanced detection, we can use a basic log monitoring tool like **Logwatch** or **Fail2Ban**. In this case, we'll simulate using Logwatch to monitor the login attempts.

1. **Simulate Logwatch Usage**: Logwatch is a tool that processes system logs and sends periodic reports of suspicious events. Install and configure it on a Linux system (if you're using a local environment).

   On Linux, you can install Logwatch via:

   ```bash
   sudo apt-get install logwatch
   ```

2. **Configure Logwatch**: Configure Logwatch to monitor `access.log` by editing its configuration:

   Edit the `logwatch.conf` file or create a custom configuration for your web app logs:

   ```bash
   sudo nano /etc/logwatch/conf/logfiles/your_app_log.conf
   ```

   In this file, specify the log file path (e.g., `/path/to/access.log`).

#### **Step 2: Simulate Real-Time Alerts**

Simulate suspicious activity by triggering multiple failed login attempts within a short period (e.g., 5 attempts within 5 minutes).

1. Test the login functionality multiple times with incorrect credentials to generate failed login logs.
2. Once you've generated enough failed login attempts, configure **Logwatch** or use any log monitoring system to alert you.

**Example of Logwatch alert**:

```txt
Subject: Logwatch for your Web Application - Suspicious Login Activity Detected

Dear Admin,

The following suspicious activity has been detected on your web application:

Failed login attempts detected from IP 192.168.1.100:
- 5 failed login attempts within 5 minutes.

This may indicate a potential brute-force attack.

Please take appropriate action.

Regards,
Your Web Application Security Monitoring System
```

#### **Step 3: Automate the Detection and Response**

To automate the response, you can configure **Fail2Ban** (or a similar tool) to block IPs after a certain number of failed login attempts.

1. **Install Fail2Ban**:

   ```bash
   sudo apt-get install fail2ban
   ```

2. **Configure Fail2Ban**: Set up a custom filter to monitor your `access.log` and block IPs with too many failed login attempts.

   Example configuration (you may need to adjust paths and parameters for your system):

   ```bash
   sudo nano /etc/fail2ban/jail.local
   ```

   Add the following configuration:

   ```bash
   [your-app]
   enabled = true
   filter = your-app-filter
   logpath = /path/to/access.log
   maxretry = 3
   bantime = 3600
   findtime = 3600
   action = iptables[name=your-app, port=http, protocol=tcp]
   ```

3. **Test the Block**: After several failed login attempts from the same IP, **Fail2Ban** should automatically block that IP.

**Reflection Questions**:
- How does automated detection and blocking of suspicious IPs help prevent brute-force attacks?
- Why is real-time alerting important for web application security?

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
- Simulated real-time monitoring and alerting for suspicious activities using tools like Logwatch and Fail2Ban.
- Learned how real-time alerts and automated responses can significantly improve your web application's security posture.

---

Let me know if you're ready to move to the next topic or need more details!