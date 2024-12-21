
### **Lab 5: Sensitive Data Exposure**

#### **Objective:**
In this lab, you will:
1. Understand the risks associated with sensitive data exposure.
2. Learn about how attackers can exploit weak data protection mechanisms.
3. Implement proper encryption and secure communication protocols to protect sensitive data.

---

### **Task 1: Exploit Sensitive Data Exposure**

#### **Step 1: Set Up the Vulnerable Web Application**

1. **Create a new folder** for the Sensitive Data Exposure lab, e.g., `Lab6_SensitiveDataExposure`.
2. Inside the folder, create two files:
   - `login.html` (for the login form)
   - `process_login.php` (to handle login requests and expose sensitive data)

#### **Step 2: Implement the Vulnerable Code**

- **login.html**: This file will contain a simple login form where users can enter their username and password. We'll simulate transmitting the data insecurely (without HTTPS) and storing passwords in plain text.

  ```html
  <!DOCTYPE html>
  <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Sensitive Data Exposure Example</title>
      </head>
      <body>
          <h1>Login Form</h1>
          <form action="process_login.php" method="post">
              <label for="username">Username:</label>
              <input type="text" id="username" name="username" required><br>
              <label for="password">Password:</label>
              <input type="password" id="password" name="password" required><br>
              <button type="submit">Login</button>
          </form>
      </body>
  </html>
  ```

- **process_login.php**: This PHP file will simulate the process of logging in. It will take user credentials and store them in plain text. The password will also be transmitted in an insecure manner (over HTTP instead of HTTPS).

  ```php
  <?php
  // Simulate a database with hardcoded username and password
  $stored_username = "user";
  $stored_password = "password123"; // Stored as plain text (vulnerable)

  // Capture user input
  $user_input_username = $_POST['username'];
  $user_input_password = $_POST['password'];

  // Simulate a login check
  if ($user_input_username == $stored_username && $user_input_password == $stored_password) {
      echo "<h2>Welcome, $user_input_username!</h2>";
      echo "<p>Your sensitive data is now exposed (in plaintext). This is insecure!</p>";
  } else {
      echo "<h2>Invalid credentials. Try again.</h2>";
  }
  ?>
  ```

#### **Step 3: Exploit the Vulnerability**

1. **Test the form**: Open the `login.html` file in a browser and submit the login form using the correct credentials (`username: user`, `password: password123`).
2. **Observe** that after a successful login, the page displays the user's credentials in plaintext (i.e., the password is not encrypted).
3. **Test transmitting over HTTP**: Try intercepting the data using a tool like **Wireshark** or **Burp Suite**. Since no encryption is applied, you can see the username and password being transmitted over the network in plain text.

**Reflection Questions**:
- What are the risks of transmitting sensitive data over HTTP?
- How could an attacker exploit the lack of encryption during the transmission of sensitive data?

---

### **Task 2: Mitigate Sensitive Data Exposure**

#### **Step 1: Implement Secure Transmission with HTTPS**

To mitigate sensitive data exposure, we need to ensure that all sensitive data is transmitted securely. We'll implement HTTPS (SSL/TLS) for secure communication between the client and the server.

1. **Set up SSL/TLS**: If you're running this lab locally, you can use **self-signed certificates** for SSL/TLS, or if you're deploying this on a live server, use a trusted certificate authority (CA).
   
2. Modify the **form action** in the `login.html` to use `https` instead of `http`.

   ```html
   <form action="https://localhost/process_login.php" method="post">
   ```

3. Ensure your server is configured to use HTTPS. If you're using **Apache**, you can enable SSL by editing the configuration files and pointing to the SSL certificate files.

#### **Step 2: Secure Password Storage Using Hashing**

We need to secure the password storage by using **password hashing** to store passwords in a more secure manner.

1. **Modify** the `process_login.php` file to hash the password using `password_hash()` and then verify it using `password_verify()`.

   ```php
   <?php
   // Securely store the password using bcrypt
   $stored_username = "user";
   $stored_password_hash = '$2y$10$8N5f6eQmJ0nExI0ktHJ9euX0V/qwjo7ejj64ZPaAlcxL2w5Xhbn3K'; // password123 hashed using bcrypt

   // Capture user input
   $user_input_username = $_POST['username'];
   $user_input_password = $_POST['password'];

   // Check if the user input matches the stored username and the hashed password
   if ($user_input_username == $stored_username && password_verify($user_input_password, $stored_password_hash)) {
       echo "<h2>Welcome, $user_input_username!</h2>";
       echo "<p>Your sensitive data is now protected with hashing and secure transmission.</p>";
   } else {
       echo "<h2>Invalid credentials. Try again.</h2>";
   }
   ?>
   ```

#### **Step 3: Test the Mitigated Version**

1. **Test with HTTPS**: Make sure that your application now uses HTTPS for secure data transmission. You can verify this by checking for the padlock icon in the browser’s address bar.
2. **Test the login functionality**: Submit the form using the correct credentials. The page should now securely authenticate the user, and the password will be stored as a hashed value, preventing exposure of sensitive data.

**Reflection Questions**:
- How does using HTTPS protect the sensitive data transmitted between the client and server?
- Why is it important to hash passwords before storing them?
- Can you think of any additional steps to improve the security of sensitive data in this application?

---

### **Deliverables**

For this assignment, submit the following files:

1. **`login.html`** – The login form with a secure connection (HTTPS).
2. **`process_login.php`** – The PHP script with both insecure and secure versions (with hashed passwords and HTTPS).
3. **`README.md`** – A brief explanation document that includes:
   - A description of the sensitive data exposure vulnerability.
   - How you exploited the vulnerability in Task 1.
   - How you mitigated the vulnerability in Task 2 using HTTPS and password hashing.
   - Your thoughts on the importance of securing sensitive data.

---

### **Summary**

In this lab, you:
- Learned about **sensitive data exposure** vulnerabilities and their risks.
- Exploited an insecure login system where passwords were stored in plain text and transmitted over HTTP.
- Mitigated these vulnerabilities by implementing **HTTPS** for secure communication and **password hashing** for secure password storage.

### **Reflection**

Protecting sensitive data is critical to maintaining the integrity and trustworthiness of your application. Always ensure that sensitive data is transmitted securely using HTTPS and stored securely using techniques like password hashing.

---

Let me know if you need any further details or if you'd like to move on to the next topic!