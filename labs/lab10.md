
### **Lab 10: Using Components with Known Vulnerabilities**

#### **Objective:**
In this lab, you will:
1. Learn about **components with known vulnerabilities**.
2. Understand how to identify vulnerable components in your application.
3. Explore how to mitigate the risks associated with using vulnerable components by updating or replacing them.

---

### **Task 1: Exploit a Vulnerable Component**

#### **Step 1: Set Up a Web Application Using a Vulnerable Component**

1. **Create a new folder** for the vulnerable component lab, e.g., `Lab11_VulnerableComponents`.
2. Inside the folder, create the following files:
   - `index.php` (a page that simulates the vulnerable application)

3. **Simulate a vulnerable component**: Use an outdated and insecure version of a common library like jQuery or an older version of a PHP framework.

   For example, let's use an old version of jQuery (v1.3.2), which contains known vulnerabilities. Download the old version of jQuery and include it in your project:

   - Download [jQuery 1.3.2](https://code.jquery.com/jquery-1.3.2.min.js) and save it in the project folder.

4. **index.php**: Include the old jQuery version and create a vulnerable application that uses it.

   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title>Vulnerable Component Example</title>
       <script src="jquery-1.3.2.min.js"></script> <!-- Old jQuery version -->
   </head>
   <body>
       <h1>Vulnerable Web Application</h1>
       <p>Click the button below to execute a function that is vulnerable to DOM-based XSS.</p>
       <button id="vulnerableBtn">Click Me</button>

       <script>
           // A vulnerable function that uses jQuery's old .html() method unsafely
           $('#vulnerableBtn').click(function() {
               var userInput = prompt("Enter some text:");
               $('#vulnerableBtn').html(userInput); // Vulnerable to XSS in old jQuery
           });
       </script>
   </body>
   </html>
   ```

#### **Step 2: Exploit the Vulnerable Component**

1. **Test the vulnerability**: Open the application in a browser and click the button. When prompted for input, enter the following malicious payload:

   ```html
   <script>alert('XSS Vulnerability Exploited');</script>
   ```

2. **Observe the result**: The script will execute because the old jQuery version is vulnerable to DOM-based XSS due to its unsafe use of `.html()` to insert untrusted data into the page.

**Reflection Questions**:
- What are the risks associated with using outdated components like old jQuery versions?
- How did the use of an outdated component lead to the exploitation of a vulnerability?

---

### **Task 2: Mitigate the Vulnerability**

#### **Step 1: Update or Replace the Vulnerable Component**

To mitigate the vulnerability, update the vulnerable component to a newer, secure version. In this case, you will update jQuery to a modern, secure version.

1. **Update jQuery**: Download the latest version of jQuery (e.g., v3.x.x) from [jQuery's official website](https://jquery.com/download/), and replace the old version with the new one in your `index.php` file.

   ```html
   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- Updated jQuery version -->
   ```

2. **Replace insecure code**: After updating jQuery, modify the code to ensure proper input handling, making it safer.

   ```html
   <script>
       $('#vulnerableBtn').click(function() {
           var userInput = prompt("Enter some text:");
           // Use text() instead of html() to prevent XSS
           $('#vulnerableBtn').text(userInput); // Safely insert text without executing it
       });
   </script>
   ```

#### **Step 2: Test the Mitigated Version**

1. **Test the new implementation**: Open the updated application in the browser and click the button again. This time, enter the same malicious payload (`<script>alert('XSS Vulnerability Exploited');</script>`).
   
2. **Observe the result**: The script should no longer execute, as the new version of jQuery uses safer methods like `.text()` for inserting user input.

**Reflection Questions**:
- How did updating the jQuery version help mitigate the XSS vulnerability?
- How does using the correct jQuery methods (e.g., `.text()` instead of `.html()`) contribute to secure development?

---

### **Deliverables**

For this assignment, submit the following files:

1. **`index.php`** – The vulnerable web application (before and after the update).
2. **`README.md`** – A brief explanation document that includes:
   - A description of the vulnerability introduced by using outdated components.
   - How you exploited the vulnerability in Task 1.
   - How you mitigated the vulnerability in Task 2 by updating the component and fixing the code.
   - Your thoughts on the importance of keeping software components updated to avoid vulnerabilities.

---

### **Summary**

In this lab, you:
- Learned about **components with known vulnerabilities** and the risks they introduce.
- Exploited a vulnerability caused by using an outdated version of jQuery that was susceptible to DOM-based XSS.
- Mitigated the vulnerability by updating the jQuery version and fixing the code to use safer methods for handling user input.

### **Reflection**

Using outdated components is a significant security risk, as these components often contain known vulnerabilities that attackers can exploit. Keeping software up-to-date and using secure coding practices are essential for maintaining a safe and secure application.

---
