
### **Lab 3: Command Injection**

#### **Objective:**
In this lab, you will:
1. Understand what command injection vulnerabilities are.
2. Learn how attackers can exploit command injection.
3. Apply basic mitigation techniques to prevent command injection vulnerabilities.

---

### **Task 1: Exploit Command Injection Vulnerability**

#### **Step 1: Set Up the Vulnerable Web Application**

1. **Create a new folder** for your command injection lab, e.g., `Lab4_CommandInjection`.
2. Inside this folder, create two files:
   - `index.html` (for the form)
   - `command.php` (to execute the system command)

#### **Step 2: Implement the Vulnerable Code**

- **index.html**: This file will contain a simple form where users can submit a domain or IP address, and the server will execute a system command (ping the given address).

  ```html
  <!DOCTYPE html>
  <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Command Injection Example</title>
      </head>
      <body>
          <h1>Command Injection Test</h1>
          <form action="command.php" method="post">
              <label for="domain">Enter a domain or IP address:</label>
              <input type="text" id="domain" name="domain">
              <button type="submit">Submit</button>
          </form>
      </body>
  </html>
  ```

- **command.php**: This PHP file will execute a system command (using `exec()`) to ping the entered domain or IP address. The code is intentionally vulnerable to command injection.

  ```php
  <?php
  if (isset($_POST['domain'])) {
      $domain = $_POST['domain'];

      // Vulnerable to command injection: directly using user input in system command
      $output = shell_exec("ping -c 4 " . $domain); // Linux command, change to `ping -n 4` on Windows
      echo "<pre>$output</pre>";
  }
  ?>
  ```

#### **Step 3: Exploit the Vulnerability**

1. **Open** the `index.html` file in your web browser.
2. **Submit** the following input in the "domain" field to exploit the command injection vulnerability:
   ```
   example.com; ls -la
   ```
   This will cause the server to run the `ping` command followed by `ls -la` (listing directory contents).

3. **Observe the behavior**: The server should display the result of the `ping` command along with the directory listing, demonstrating that the attacker can execute arbitrary commands on the server.

**Reflection Questions**:
- How does the `;` symbol allow an attacker to chain commands together?
- What risks are involved when web applications execute system commands based on user input?

---

### **Task 2: Mitigate Command Injection Vulnerability**

#### **Step 1: Fix the Vulnerability**

To mitigate the command injection vulnerability, you must validate and sanitize the user input before executing system commands. The `escapeshellcmd()` function in PHP can be used to prevent command injection by escaping any special characters that could be interpreted as part of a command.

1. **Modify** the `command.php` file as follows to prevent command injection:

  ```php
  <?php
  if (isset($_POST['domain'])) {
      $domain = $_POST['domain'];

      // Mitigate the command injection vulnerability
      $safe_domain = escapeshellcmd($domain);

      // Safely execute the ping command
      $output = shell_exec("ping -c 4 " . $safe_domain); // Linux command, change to `ping -n 4` on Windows
      echo "<pre>$output</pre>";
  }
  ?>
  ```

#### **Step 2: Test the Mitigated Version**

1. **Open** the `index.html` form again in the browser.
2. **Submit** the same malicious input (`example.com; ls -la`).
3. **Observe** that the `ls -la` command will no longer be executed, and only the result of the `ping` command will be shown, demonstrating that the vulnerability has been mitigated.

**Reflection Questions**:
- How does the `escapeshellcmd()` function prevent command injection?
- Why is it important to sanitize user input before using it in system commands?
- Can you think of other ways to secure this functionality?

---

### **Deliverables**

Please submit the following files for this assignment:

1. **`index.html`** – The form for entering domain or IP address.
2. **`command.php`** – The PHP script, both the vulnerable and mitigated versions.
3. **`README.md`** – A brief explanation document that includes:
   - A description of the command injection vulnerability.
   - How you exploited the vulnerability in Task 1.
   - How you fixed the vulnerability in Task 2 using `escapeshellcmd()`.
   - Your thoughts on the importance of input validation in securing web applications.

---

### **Summary**

In this lab, you:
- Learned about **command injection** and how attackers can exploit it to execute arbitrary commands on the server.
- Exploited a vulnerable PHP application that executed system commands based on user input.
- Applied a security measure (`escapeshellcmd()`) to mitigate the command injection vulnerability.

### **Reflection**

As you continue exploring web security, remember that **command injection** vulnerabilities can allow attackers to gain control over the underlying system. Always sanitize and validate user input to protect your applications from such attacks.

---
