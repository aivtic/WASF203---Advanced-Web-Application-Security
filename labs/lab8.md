
### **Lab 8: Security Misconfiguration**

#### **Objective:**
In this lab, you will:
1. Understand what **Security Misconfiguration** vulnerabilities are.
2. Identify common security misconfigurations in web applications.
3. Mitigate security misconfigurations through proper configurations and hardening.

---

### **Task 1: Exploit Security Misconfiguration**

#### **Step 1: Set Up the Vulnerable Web Application**

1. **Create a new folder** for the Security Misconfiguration lab, e.g., `Lab9_SecurityMisconfiguration`.
2. Inside the folder, create the following files:
   - `index.php` (a basic page of the web application)
   - `.htaccess` (an insecure `.htaccess` file)
   - `config.php` (a configuration file with sensitive information)

#### **Step 2: Implement the Vulnerable Code**

- **index.php**: This is a simple web page that simulates a login screen and displays some sensitive information.

  ```php
  <?php
  // Check if the user is logged in
  session_start();

  if (!isset($_SESSION['username'])) {
      echo "<p>Please log in to view the page.</p>";
  } else {
      echo "<h2>Welcome to the User Dashboard</h2>";
      echo "<p>This page is for logged-in users.</p>";
  }
  ?>
  ```

- **.htaccess**: This file, if not properly configured, can expose sensitive files or allow unauthorized access to certain parts of the application. This is a basic misconfiguration where the file is accessible from the web.

  ```
  # .htaccess with improper configurations
  # This file should restrict access to sensitive files, but it is left open to the public

  <Files ".ht*">
      Order Allow,Deny
      Deny from all
  </Files>

  # But it's missing the configuration to block access to files such as 'config.php'
  ```

- **config.php**: This file contains sensitive information such as database credentials. In a misconfigured environment, such files could be exposed to attackers.

  ```php
  <?php
  // Database credentials – this file should NOT be publicly accessible
  $db_host = 'localhost';
  $db_user = 'root';
  $db_pass = 'password';
  $db_name = 'mydatabase';
  ```

#### **Step 3: Exploit the Vulnerability**

1. **Access `.htaccess`**: Try to access the `.htaccess` file directly through the browser by navigating to `http://localhost/.htaccess`. This should not be allowed, but in case the configuration is incorrect, you may be able to view its content.
   
2. **Access `config.php`**: Try to access the `config.php` file directly by navigating to `http://localhost/config.php`. If the file is misconfigured and publicly accessible, you will see the sensitive database credentials.

**Reflection Questions**:
- What kind of sensitive information can attackers gain by exploiting misconfigurations?
- How can access to `.htaccess` or `config.php` be restricted to prevent unauthorized access?

---

### **Task 2: Mitigate Security Misconfiguration**

#### **Step 1: Correctly Configure `.htaccess`**

To mitigate this misconfiguration, you should prevent access to sensitive files like `.htaccess` and `config.php`. Here's how to properly secure the `.htaccess` file:

1. **Update the `.htaccess` file** to restrict access to sensitive files:

   ```
   # .htaccess with proper security configurations
   # Restrict access to sensitive files
   <Files ".ht*">
       Order Allow,Deny
       Deny from all
   </Files>

   <Files "config.php">
       Order Allow,Deny
       Deny from all
   </Files>
   ```

#### **Step 2: Secure the `config.php` File**

1. **Move the `config.php` file** to a location outside of the publicly accessible web root directory (e.g., a `config` directory that is not directly accessible via the web).

2. **Modify the path** in your PHP application to point to the new location of the `config.php` file. For example, if you move `config.php` to the parent directory, update the `index.php` or any other file that uses it:

   ```php
   // Include the config file from the new location outside the public web root
   include('../config/config.php');
   ```

3. **Check the file permissions** of sensitive files to ensure they are only readable by authorized users (e.g., your web server and administrators).

#### **Step 3: Test the Mitigated Version**

1. **Test the `.htaccess` configuration**: Try accessing the `.htaccess` file or the `config.php` file directly through the browser. Both should now return a "Forbidden" message, preventing unauthorized access.
   
2. **Test the `config.php` file**: Ensure that the `config.php` file is no longer accessible via the web browser by trying to access it directly. If properly configured, you should see a 403 Forbidden error.

**Reflection Questions**:
- How did moving the `config.php` file out of the public web root improve security?
- How do proper file permissions and access control contribute to the overall security of the web application?

---

### **Deliverables**

For this assignment, submit the following files:

1. **`.htaccess`** – The updated `.htaccess` file with proper security configurations.
2. **`config.php`** – The updated configuration file (if moved, make sure to include the new path and relevant changes).
3. **`index.php`** – The updated index page that uses the properly secured `config.php`.
4. **`README.md`** – A brief explanation document that includes:
   - A description of the Security Misconfiguration vulnerability.
   - How you exploited the vulnerability in Task 1.
   - How you mitigated the vulnerability in Task 2 by securing the `.htaccess` file and `config.php`.
   - Your thoughts on the importance of proper configuration management.

---

### **Summary**

In this lab, you:
- Learned about **Security Misconfiguration** vulnerabilities and their risks.
- Exploited a misconfiguration where sensitive files like `.htaccess` and `config.php` were publicly accessible.
- Mitigated the misconfiguration by securing access to sensitive files and properly configuring the `.htaccess` file.

### **Reflection**

Security misconfigurations are a common vulnerability in many web applications. By ensuring that files containing sensitive information are properly protected and not accessible from the web, you can significantly reduce the risk of exploitation.

---
