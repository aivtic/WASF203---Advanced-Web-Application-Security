
### **Lab 5: Broken Access Control**

#### **Objective:**
In this lab, you will:
1. Learn about **Broken Access Control** vulnerabilities.
2. Understand how attackers can exploit these vulnerabilities to access unauthorized resources.
3. Mitigate access control flaws by implementing proper authorization mechanisms.

---

### **Task 1: Exploit Broken Access Control**

#### **Step 1: Set Up the Vulnerable Web Application**

1. **Create a new folder** for the Broken Access Control lab, e.g., `Lab8_BrokenAccessControl`.
2. Inside the folder, create two files:
   - `admin_dashboard.php` (a page intended for admin users)
   - `user_dashboard.php` (a page intended for regular users)
   - `login.php` (a login page where users can authenticate)

#### **Step 2: Implement the Vulnerable Code**

- **admin_dashboard.php**: This page is intended for admin users but does not properly check if the logged-in user is an admin.

  ```php
  <?php
  session_start();

  // Simulating logged-in user
  $_SESSION['username'] = 'user';  // Change to 'admin' to simulate an admin login

  if (!isset($_SESSION['username'])) {
      header("Location: login.php");
      exit();
  }

  echo "<h2>Welcome to the Admin Dashboard</h2>";
  echo "<p>This is a secret admin page!</p>";
  ?>

  <a href="user_dashboard.php">Go to User Dashboard</a>
  ```

- **user_dashboard.php**: This page is intended for regular users. However, it doesn't have proper access control, so an attacker can access this page by simply changing the URL.

  ```php
  <?php
  session_start();

  // Simulating logged-in user
  $_SESSION['username'] = 'user';  // You can modify this to simulate admin or other users

  if (!isset($_SESSION['username'])) {
      header("Location: login.php");
      exit();
  }

  echo "<h2>Welcome to the User Dashboard</h2>";
  echo "<p>This page is for regular users.</p>";
  ?>

  <a href="admin_dashboard.php">Go to Admin Dashboard</a>
  ```

- **login.php**: This page allows users to log in but does not check their roles or permissions.

  ```php
  <?php
  session_start();

  if ($_SERVER['REQUEST_METHOD'] == 'POST') {
      $username = $_POST['username'];
      $password = $_POST['password'];

      // Hardcoded username and password
      if ($username == 'admin' && $password == 'admin123') {
          $_SESSION['username'] = 'admin';
          header("Location: admin_dashboard.php");
      } elseif ($username == 'user' && $password == 'user123') {
          $_SESSION['username'] = 'user';
          header("Location: user_dashboard.php");
      } else {
          echo "<p>Invalid credentials</p>";
      }
  }
  ?>

  <form action="login.php" method="post">
      <label for="username">Username:</label>
      <input type="text" id="username" name="username" required><br>
      <label for="password">Password:</label>
      <input type="password" id="password" name="password" required><br>
      <button type="submit">Login</button>
  </form>
  ```

#### **Step 3: Exploit the Vulnerability**

1. **Login as a user**: Log in with the credentials `user` and `user123`.
2. **Attempt to access the admin page**: Change the URL to `admin_dashboard.php` in the browser address bar.
3. **Observe** that the user can access the admin page without proper authorization, demonstrating a **Broken Access Control** vulnerability.

**Reflection Questions**:
- What type of access control vulnerability was exploited in this scenario?
- How could this vulnerability allow an attacker to gain unauthorized access to sensitive resources?

---

### **Task 2: Mitigate Broken Access Control**

#### **Step 1: Implement Proper Access Control**

We will now implement proper access control to ensure that only authenticated and authorized users can access the admin dashboard.

1. **Modify the `admin_dashboard.php`** page to check the user's role:

   ```php
   <?php
   session_start();

   if (!isset($_SESSION['username'])) {
       header("Location: login.php");
       exit();
   }

   // Check if the user is an admin
   if ($_SESSION['username'] !== 'admin') {
       echo "<p>Access denied. You are not authorized to view this page.</p>";
       exit();
   }

   echo "<h2>Welcome to the Admin Dashboard</h2>";
   echo "<p>This is a secret admin page!</p>";
   ?>
   ```

2. **Modify the `user_dashboard.php`** page to ensure that it can only be accessed by a logged-in user:

   ```php
   <?php
   session_start();

   if (!isset($_SESSION['username'])) {
       header("Location: login.php");
       exit();
   }

   echo "<h2>Welcome to the User Dashboard</h2>";
   echo "<p>This page is for regular users.</p>";
   ?>
   ```

#### **Step 2: Test the Mitigated Version**

1. **Login as a user**: Log in with the credentials `user` and `user123`.
2. **Attempt to access the admin page**: Try to access the `admin_dashboard.php` page. You should now see an access denied message, indicating that users without the `admin` role cannot access the admin dashboard.
3. **Login as an admin**: Log in with the credentials `admin` and `admin123`. You should now be able to access the admin dashboard.

**Reflection Questions**:
- How does the implemented access control mechanism prevent unauthorized access?
- What other techniques can be used to secure access control in web applications (e.g., role-based access control, attribute-based access control)?

---

### **Deliverables**

For this assignment, submit the following files:

1. **`admin_dashboard.php`** – The updated admin dashboard page with proper access control.
2. **`user_dashboard.php`** – The updated user dashboard page.
3. **`login.php`** – The login page used to authenticate users.
4. **`README.md`** – A brief explanation document that includes:
   - A description of the Broken Access Control vulnerability.
   - How you exploited the vulnerability in Task 1.
   - How you mitigated the vulnerability in Task 2 by implementing proper access control.
   - Your thoughts on the importance of implementing proper access control.

---

### **Summary**

In this lab, you:
- Learned about **Broken Access Control** vulnerabilities and their risks.
- Exploited a broken access control vulnerability that allowed unauthorized access to the admin dashboard.
- Mitigated the vulnerability by implementing role-based access control, ensuring that only authorized users can access sensitive resources.

### **Reflection**

Broken access control vulnerabilities can lead to serious security issues, including unauthorized access to sensitive data and administrative functionality. Always implement proper access control mechanisms to ensure that users only have access to the resources and actions they are authorized for.

---
