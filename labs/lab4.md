
### **Lab 4: Cross-Site Scripting (XSS)**

#### **Objective:**
In this lab, you will:
1. Learn about **Cross-Site Scripting (XSS)** vulnerabilities.
2. Understand how attackers exploit XSS to execute scripts in users' browsers.
3. Mitigate XSS vulnerabilities through proper input validation and output encoding.

---

### **Task 1: Exploit Cross-Site Scripting (XSS)**

#### **Step 1: Set Up the Vulnerable Web Application**

1. **Create a new folder** for the XSS lab, e.g., `Lab10_XSS`.
2. Inside the folder, create the following files:
   - `index.php` (a page to simulate an input form and display user-submitted content)
   - `xss_form.php` (a page where the user submits input)
   - `xss_output.php` (a page that shows the content submitted by the user)

#### **Step 2: Implement the Vulnerable Code**

- **index.php**: This page contains a simple input form where users can submit their names.

  ```php
  <form action="xss_form.php" method="post">
      <label for="name">Enter your name:</label>
      <input type="text" id="name" name="name" required><br>
      <button type="submit">Submit</button>
  </form>
  ```

- **xss_form.php**: This page takes user input and submits it without validating or sanitizing it, creating a potential XSS vulnerability.

  ```php
  <?php
  if ($_SERVER['REQUEST_METHOD'] == 'POST') {
      $name = $_POST['name'];  // Directly using user input without sanitizing

      // Vulnerability: XSS
      echo "<p>Hello, $name!</p>";  // User input is directly displayed on the page without escaping
  }
  ?>
  ```

#### **Step 3: Exploit the Vulnerability**

1. **Submit a malicious payload**: In the form on the `index.php` page, enter the following payload:

   ```html
   <script>alert('XSS Attack!');</script>
   ```

2. **Observe the result**: When the form is submitted, the script will execute in the browser and display an alert, demonstrating a **Cross-Site Scripting (XSS)** vulnerability.

**Reflection Questions**:
- What happens when a malicious script is injected into the input field?
- How can this attack be used to steal session cookies or redirect users to malicious websites?

---

### **Task 2: Mitigate Cross-Site Scripting (XSS)**

#### **Step 1: Implement Input Validation and Output Encoding**

To mitigate the XSS vulnerability, we will sanitize user input and ensure that user-submitted content is displayed safely.

1. **Modify the `xss_form.php`** page to escape user input before displaying it:

   ```php
   <?php
   if ($_SERVER['REQUEST_METHOD'] == 'POST') {
       $name = htmlspecialchars($_POST['name'], ENT_QUOTES, 'UTF-8');  // Sanitize user input

       echo "<p>Hello, $name!</p>";  // Output the sanitized input
   }
   ?>
   ```

   The `htmlspecialchars()` function encodes special characters such as `<`, `>`, and `&` to their HTML entity equivalents, preventing any HTML or JavaScript from being executed.

#### **Step 2: Test the Mitigated Version**

1. **Submit the malicious payload again**: Enter the same XSS payload (`<script>alert('XSS Attack!');</script>`) in the form and submit it.
2. **Observe the result**: This time, the input will be sanitized, and the script will not execute. Instead, the text will be displayed as plain text (`&lt;script&gt;alert('XSS Attack!');&lt;/script&gt;`), demonstrating proper output encoding and protection against XSS.

**Reflection Questions**:
- How did sanitizing the user input prevent the XSS attack?
- What is the importance of using output encoding in preventing XSS vulnerabilities?

---

### **Deliverables**

For this assignment, submit the following files:

1. **`index.php`** – The input form page.
2. **`xss_form.php`** – The page where user input is displayed (before and after mitigation).
3. **`README.md`** – A brief explanation document that includes:
   - A description of Cross-Site Scripting (XSS) vulnerabilities.
   - How you exploited the vulnerability in Task 1.
   - How you mitigated the vulnerability in Task 2 by sanitizing and encoding user input.
   - Your thoughts on the importance of input validation and output encoding in preventing XSS.

---

### **Summary**

In this lab, you:
- Learned about **Cross-Site Scripting (XSS)** vulnerabilities and their risks.
- Exploited an XSS vulnerability by injecting a malicious script through a form input.
- Mitigated the vulnerability by properly sanitizing and encoding user input using `htmlspecialchars()`.

### **Reflection**

Cross-Site Scripting is a common and dangerous vulnerability, but it can be mitigated effectively by ensuring proper input validation and output encoding. It's important to always validate and sanitize user input, especially when it's displayed back to the user, to prevent malicious attacks.

---
