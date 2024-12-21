
### **Lab 6: XML External Entity (XXE) Vulnerability**

#### **Objective:**
In this lab, you will:
1. Learn about **XML External Entity (XXE)** vulnerabilities.
2. Understand how attackers can exploit XXE flaws to read sensitive files or cause denial-of-service attacks.
3. Mitigate XXE vulnerabilities by configuring XML parsers securely.

---

### **Task 1: Exploit XML External Entity (XXE)**

#### **Step 1: Set Up the Vulnerable Web Application**

1. **Create a new folder** for the XXE vulnerability lab, e.g., `Lab7_XXE`.
2. Inside the folder, create two files:
   - `upload.xml` (a file that simulates an XML file with sensitive data)
   - `process_xml.php` (to handle XML file uploads and process them)

#### **Step 2: Implement the Vulnerable Code**

- **upload.xml**: This file contains an XML structure with an external entity that attempts to read a sensitive file (e.g., `/etc/passwd` on a Linux system).

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE foo [
      <!ELEMENT foo ANY >
      <!ENTITY xxe SYSTEM "file:///etc/passwd">
  ]>
  <foo>
      <bar>&xxe;</bar>
  </foo>
  ```

  The `xxe` entity attempts to read the `/etc/passwd` file, which is a common target for this kind of attack.

- **process_xml.php**: This PHP file processes the uploaded XML file and outputs the content. However, it uses the **DOMDocument** class, which is vulnerable to XXE by default.

  ```php
  <?php
  // Check if a file was uploaded
  if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['xmlfile'])) {
      $file = $_FILES['xmlfile']['tmp_name'];

      // Load the XML file
      $xml = new DOMDocument();
      $xml->load($file); // This will process the XML, and if it contains an XXE, it will be executed

      // Display the XML content
      echo "<h2>XML Content:</h2>";
      echo "<pre>" . htmlspecialchars($xml->saveXML()) . "</pre>";
  }
  ?>

  <!-- HTML form for uploading the XML file -->
  <form action="process_xml.php" method="post" enctype="multipart/form-data">
      <label for="xmlfile">Upload XML File:</label>
      <input type="file" id="xmlfile" name="xmlfile" required><br>
      <button type="submit">Upload and Process</button>
  </form>
  ```

#### **Step 3: Exploit the Vulnerability**

1. **Upload the `upload.xml` file** through the form in `process_xml.php`.
2. **Observe** that the contents of the `/etc/passwd` file are included in the response, revealing sensitive system information. This demonstrates the XXE vulnerability.

**Reflection Questions**:
- What type of information can an attacker gain from exploiting an XXE vulnerability?
- How would an attacker use an XXE vulnerability to escalate their privileges or compromise the system?

---

### **Task 2: Mitigate XML External Entity (XXE)**

#### **Step 1: Disable External Entity Processing**

To prevent XXE vulnerabilities, we must disable external entity processing in the XML parser. For example, when using **DOMDocument** in PHP, we can configure it to prevent external entity loading.

1. **Modify** the `process_xml.php` file to disable external entity processing:

   ```php
   <?php
   // Check if a file was uploaded
   if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['xmlfile'])) {
       $file = $_FILES['xmlfile']['tmp_name'];

       // Create a new DOMDocument instance
       $xml = new DOMDocument();

       // Disable external entity processing
       libxml_disable_entity_loader(true);

       // Load the XML file securely
       $xml->load($file); // This will now prevent XXE attacks

       // Display the XML content
       echo "<h2>XML Content:</h2>";
       echo "<pre>" . htmlspecialchars($xml->saveXML()) . "</pre>";
   }
   ?>

   <!-- HTML form for uploading the XML file -->
   <form action="process_xml.php" method="post" enctype="multipart/form-data">
       <label for="xmlfile">Upload XML File:</label>
       <input type="file" id="xmlfile" name="xmlfile" required><br>
       <button type="submit">Upload and Process</button>
   </form>
   ```

2. In the above code:
   - `libxml_disable_entity_loader(true)` disables the external entity loading to prevent XXE attacks.

#### **Step 2: Test the Mitigated Version**

1. **Upload the same `upload.xml` file** again. This time, the contents of `/etc/passwd` should not be returned, and the attack will fail.
2. **Verify** that the application no longer processes external entities and the sensitive data is protected.

**Reflection Questions**:
- How does disabling external entity loading protect the application from XXE attacks?
- What are other best practices to prevent XXE vulnerabilities in web applications?

---

### **Deliverables**

For this assignment, submit the following files:

1. **`upload.xml`** – The malicious XML file used for the XXE attack.
2. **`process_xml.php`** – The PHP script, including both the vulnerable and secure versions.
3. **`README.md`** – A brief explanation document that includes:
   - A description of the XXE vulnerability.
   - How you exploited the vulnerability in Task 1.
   - How you mitigated the vulnerability in Task 2 by disabling external entity loading.
   - Your thoughts on the importance of securing XML parsers.

---

### **Summary**

In this lab, you:
- Learned about **XML External Entity (XXE)** vulnerabilities and their risks.
- Exploited an XXE vulnerability in an XML parser that allowed you to read sensitive files.
- Mitigated the XXE vulnerability by disabling external entity processing in the XML parser.

### **Reflection**

XML External Entity vulnerabilities can be extremely dangerous, allowing attackers to read sensitive files, execute denial-of-service attacks, or even perform server-side request forgery (SSRF). Always ensure that external entity processing is disabled when using XML parsers.

---
