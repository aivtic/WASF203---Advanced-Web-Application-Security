
### **Lab 4: Broken Authentication**

#### **Objective:**
In this lab, you will:
1. Learn about broken authentication vulnerabilities.
2. Explore how attackers can exploit weak authentication systems.
3. Understand how to mitigate broken authentication vulnerabilities using secure password handling and session management.

---

### **Task 1: Exploit Broken Authentication**

#### **Step 1: Set Up the Vulnerable Web Application**

1. **Create a new folder** for your Broken Authentication lab, e.g., `Lab5_BrokenAuthentication`.
2. Inside the folder, create two files:
   - `login.html` (for the login form)
   - `authenticate.php` (for checking credentials and handling sessions)

#### **Step 2: Implement the Vulnerable Code**

- **login.html**: This file contains a simple login form where users can enter their username and password.

  ```html
  <!DOCTYPE html>
  <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Broken Authentication Example</title>
      </head>
      <body>
          <h1>Login Form</h1>
          <form action="authenticate.php" method="post">
              <label for="username">Username:</label>
              <input type="text" id="username" name="username" required><br>
              <label for="password">Password:</label>
              <input type="password" id="password" name="password" required><br>
              <button type="submit">Login</button>
          </form>
      </body>
  </html>
  ```

- **authenticate.php**: This PHP file contains logic for checking the credentials, but it uses **insecure password handling** (storing passwords in plain text) and **doesn’t properly secure sessions**.

  ```php
  <?php
  // Simulate a database with hardcoded username and password
  $username = "user";
  $password = "password123"; // Stored as plain text (vulnerable)

  // Capture user input
  $user_input_username = $_POST['username'];
  $user_input_password = $_POST['password'];

  // Insecure login check: plaintext password comparison
  if ($user_input_username == $username && $user_input_password == $password) {
      // Insecure session handling: no session tokens, just a simple message
      echo "<h2>Welcome, $username!</h2>";
      echo "<p>You are logged in. However, this is insecure!</p>";
  } else {
      echo "<h2>Invalid credentials. Try again.</h2>";
  }
  ?>
  ```

#### **Step 3: Exploit the Vulnerability**

1. **Open** the `login.html` file in your browser and attempt to log in using the correct credentials (`username: user`, `password: password123`).
2. **Observe** that upon successful login, the page simply displays a welcome message. This indicates a potential issue: **the password is stored in plain text**, and there's no session management.

3. Try the following attack vectors:
   - **Password Cracking**: Since the password is stored as plain text, a hacker could easily crack it if they gain access to the database.
   - **Session Hijacking**: Without proper session management (e.g., session tokens, cookies), an attacker could manipulate requests and access resources without proper authentication.

**Reflection Questions**:
- Why is storing passwords in plain text a security risk?
- How could an attacker exploit the lack of session management?

---

### **Task 2: Mitigate Broken Authentication**

#### **Step 1: Secure the Password Storage**

To mitigate the broken authentication vulnerability, we need to **hash** the password before storing it. We’ll use PHP’s `password_hash()` function to securely hash the password and `password_verify()` to check it.

1. **Modify** the `authenticate.php` file to hash the password and verify it securely.

  ```php
  <?php
  // Securely store password using password_hash()
  $username = "user";
  $hashed_password = '$2y$10$8N5f6eQmJ0nExI0ktHJ9euX0V/qwjo7ejj64ZPaAlcxL2w5Xhbn3K'; // password123 hashed using bcrypt

  // Capture user input
  $user_input_username = $_POST['username'];
  $user_input_password = $_POST['password'];

  // Use password_verify to securely compare the user input with the hashed password
  if ($user_input_username == $username && password_verify($user_input_password, $hashed_password)) {
      // Secure session handling: initiate a session with proper session management
      session_start();
      $_SESSION['username'] = $user_input_username;
      echo "<h2>Welcome, $username!</h2>";
      echo "<p>You are logged in securely.</p>";
  } else {
      echo "<h2>Invalid credentials. Try again.</h2>";
  }
  ?>
  ```

#### **Step 2: Secure Session Management**

1. **Start a session** using `session_start()`, and store the username in a session variable.
2. Implement **session regeneration** on successful login to prevent session fixation attacks (e.g., by using `session_regenerate_id()`).

```php
session_start();
session_regenerate_id(true); // Regenerate session ID to prevent session fixation
$_SESSION['username'] = $user_input_username;
```

#### **Step 3: Test the Mitigated Version**

1. **Test the login functionality** again using the correct credentials. The page should now properly authenticate the user using hashed passwords and store session information securely.
2. Try logging in with incorrect credentials. You should see an error message indicating the failure.

**Reflection Questions**:
- How does `password_hash()` help secure passwords?
- Why is session management important, and how does `session_regenerate_id()` help prevent attacks like session fixation?

---

### **Deliverables**

For this assignment, submit the following files:

1. **`login.html`** – The login form.
2. **`authenticate.php`** – The PHP script, both the insecure and secure versions.
3. **`README.md`** – A brief explanation document that includes:
   - A description of the broken authentication vulnerability.
   - How you exploited the vulnerability in Task 1.
   - How you fixed the vulnerability in Task 2 using hashed passwords and secure session management.
   - Your thoughts on the importance of secure authentication in web applications.

---

### **Summary**

In this lab, you:
- Learned about **broken authentication** vulnerabilities and their risks.
- Exploited an insecure authentication system with plain-text password storage and improper session management.
- Mitigated these vulnerabilities by implementing **hashed password storage** and **secure session management**.

### **Reflection**

Authentication is one of the most critical components of web security. Always use secure methods for password storage, such as hashing, and ensure proper session management to prevent attackers from hijacking sessions or guessing passwords.

---
