

### **Lab 2: HTML Injection**

#### **Objective:**
In this assignment, you will:
1. Understand HTML injection vulnerabilities and how they work.
2. Learn how an attacker can exploit HTML injection.
3. Apply mitigation techniques to prevent HTML injection vulnerabilities in your web applications.

---

### **Task 1: Exploit HTML Injection Vulnerability**

#### **Step 1: Set up Your Vulnerable Web Application**

1. **Create a new folder** for your assignment. Name it `Lab2_HTMLInjection`.
2. Inside your folder, create two files:
   - `index.html`
   - `server.php`

#### **Step 2: Review and Implement the Code**

- Open your text editor (e.g., VS Code, Sublime Text) and create the following files with the given code.

- **index.html**: This file will contain a simple form where users can input their name.

  ```html
  <!DOCTYPE html>
  <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>HTML Injection Example</title>
      </head>
      <body>
          <h1>HTML Injection Test</h1>
          <form action="server.php" method="post">
              <label for="name">Name:</label>
              <input type="text" id="name" name="name">
              <button type="submit">Submit</button>
          </form>

          <?php
          if (isset($_POST['name'])) {
              echo "<h2>Hello, " . $_POST['name'] . "!</h2>";
          }
          ?>
      </body>
  </html>
  ```

- **server.php**: This PHP file processes the form input and outputs the user's name directly, which is vulnerable to HTML injection.

  ```php
  <?php
  if (isset($_POST['name'])) {
      echo "<h2>Hello, " . $_POST['name'] . "!</h2>";
  }
  ?>
  ```

#### **Step 3: Exploit the Vulnerability**

1. **Open** the `index.html` file in a web browser.
2. **Try Exploiting** the vulnerability by entering the following script into the "Name" field and clicking **Submit**:
   ```html
   <script>alert('Hacked!');</script>
   ```
3. **Observe the behavior**: A pop-up message should appear with the text "Hacked!", indicating that the JavaScript code in your input was executed. This is the HTML injection vulnerability in action.

**Reflection Questions**:
- Why does this code allow the JavaScript to execute?
- What potential risks does this vulnerability pose in a real-world application?

---

### **Task 2: Mitigate HTML Injection Vulnerability**

#### **Step 1: Fix the Vulnerability in `server.php`**

To prevent the HTML injection vulnerability, you need to sanitize the user input before displaying it. This can be done using PHP's `htmlspecialchars()` function, which converts special characters to HTML entities, preventing code from being executed.

1. **Modify** the `server.php` file to include the following sanitization technique:

  ```php
  <?php
  if (isset($_POST['name'])) {
      $safe_name = htmlspecialchars($_POST['name'], ENT_QUOTES, 'UTF-8');
      echo "<h2>Hello, $safe_name!</h2>";
  }
  ?>
  ```

#### **Step 2: Test the Mitigated Version**

1. **Open** the `index.html` form again in the browser.
2. **Submit** the same malicious input (`<script>alert('Hacked!');</script>`) again.
3. This time, the script should not execute, and instead, you should see the input displayed as text: `&lt;script&gt;alert('Hacked!');&lt;/script&gt;`.

**Reflection Questions**:
- What happens to the malicious input after applying `htmlspecialchars()`?
- How does this prevent the code from being executed?
- How do you feel about the importance of input sanitization in web security?

---

### **Deliverables**

For this assignment, please submit the following files:

1. **`index.html`** – The HTML form.
2. **`server.php`** – The PHP script with both the vulnerable and mitigated versions.
3. **`README.md`** – A short explanation document that includes:
   - A description of the HTML injection vulnerability.
   - How you exploited the vulnerability in Task 1.
   - How you fixed the vulnerability in Task 2 using `htmlspecialchars()`.
   - Any lessons learned from this assignment.

---

### **Summary**

By completing this assignment, you have:
- Gained hands-on experience in exploiting HTML injection vulnerabilities.
- Implemented a basic input sanitization technique to prevent HTML injection attacks.
  
### **Reflection**

As you progress in your security journey, remember that input validation and sanitization are crucial in preventing a wide range of attacks, including HTML injection, Cross-Site Scripting (XSS), and more. Take time to think critically about how you can apply these techniques in your future projects.

---
