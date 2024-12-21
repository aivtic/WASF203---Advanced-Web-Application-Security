
### **Lab 17: Insecure Deserialization**

#### **Objective:**
In this lab, you will:
1. Understand what insecure deserialization is and how it can be exploited.
2. Identify vulnerable applications that use insecure deserialization.
3. Implement methods to secure deserialization and prevent attacks.

---

### **Task 1: Simulate Insecure Deserialization**

#### **Step 1: Create a Vulnerable PHP Application**

1. Create a new folder for this lab, for example, `Lab17_Insecure_Deserialization`.
2. Inside this folder, create a file called `vulnerable.php`. In this file, we'll simulate insecure deserialization by unserializing data from an untrusted source.

Example `vulnerable.php`:

```php
<?php
session_start();

// Simulated class with a method that can be abused
class User {
    public $username;
    public $role;

    public function __construct($username, $role) {
        $this->username = $username;
        $this->role = $role;
    }

    // Simulated method that will be called during unserialization
    public function login() {
        echo "<h1>Welcome, " . $this->username . "!</h1>";
        echo "<p>Your role is: " . $this->role . "</p>";
    }
}

if (isset($_POST['serialized_data'])) {
    // Simulating unserialization from untrusted input
    $data = $_POST['serialized_data'];
    $user = unserialize($data);

    // Call the login method, which might be triggered on deserialization
    $user->login();
} else {
    echo "<h1>Please submit serialized data</h1>";
}
?>

<form method="POST">
    <label for="serialized_data">Serialized Data:</label><br>
    <textarea id="serialized_data" name="serialized_data" rows="5" cols="40"></textarea><br>
    <button type="submit">Submit</button>
</form>
```

In this example, the application unserializes data submitted by the user through a form. The problem here is that the data is untrusted, and an attacker could manipulate it to inject malicious code.

#### **Step 2: Manipulate Serialized Data**

1. In the `vulnerable.php` application, manually create a malicious serialized object.

For example, the serialized object for a `User` object might look like this (serialize a `User` object in PHP):

```php
$malicious_data = 'O:4:"User":2:{s:8:"username";s:4:"admin";s:4:"role";s:5:"admin";}';
```

2. Paste this string into the **serialized_data** textarea and submit the form.

By doing this, you have effectively injected a `User` object with an `admin` role, which the application will treat as valid. This is an example of **Insecure Deserialization**, as the application trusted the serialized input without validating it.

---

### **Task 2: Exploit the Vulnerability**

#### **Step 1: Exploit the Insecure Deserialization Vulnerability**

1. Go to the `vulnerable.php` page and try submitting the malicious serialized data (or any other manipulated object).
2. The application should treat the serialized object as a legitimate object, and the malicious `admin` role will be assigned.

As an attacker, this allows you to potentially gain elevated privileges or execute arbitrary code.

---

### **Task 3: Mitigating Insecure Deserialization**

#### **Step 1: Implement Safe Deserialization**

To prevent insecure deserialization, we should never trust untrusted data or deserialize it without validation. We can:

- Use `json_encode`/`json_decode` instead of PHP's `serialize`/`unserialize`.
- If you must use serialization, restrict the classes that can be unserialized using `allowed_classes`.

Let’s refactor the application to fix the deserialization vulnerability by using `json_encode`/`json_decode`.

#### **Updated `vulnerable.php` (Safe Deserialization)**

```php
<?php
session_start();

// Simulated class with a method that can be abused
class User {
    public $username;
    public $role;

    public function __construct($username, $role) {
        $this->username = $username;
        $this->role = $role;
    }

    public function login() {
        echo "<h1>Welcome, " . $this->username . "!</h1>";
        echo "<p>Your role is: " . $this->role . "</p>";
    }
}

if (isset($_POST['json_data'])) {
    // Secure deserialization using json_decode
    $data = json_decode($_POST['json_data'], true);

    // Make sure the data structure is validated before usage
    if (isset($data['username']) && isset($data['role'])) {
        $user = new User($data['username'], $data['role']);
        $user->login();
    } else {
        echo "<h1>Invalid Data</h1>";
    }
} else {
    echo "<h1>Please submit JSON data</h1>";
}
?>

<form method="POST">
    <label for="json_data">JSON Data:</label><br>
    <textarea id="json_data" name="json_data" rows="5" cols="40"></textarea><br>
    <button type="submit">Submit</button>
</form>
```

In this fixed version:
- The data is passed as a JSON string instead of a serialized object.
- The application validates that the structure of the data is correct before using it.
- The `json_decode` function is used, which is safer than PHP's `unserialize`.

#### **Step 2: Test the Mitigated Application**

1. Try submitting the same malicious serialized data as before (but now as JSON). The application should reject it as invalid data.

Example valid JSON:

```json
{"username":"admin","role":"admin"}
```

The system should accept this and log you in, but only with valid data.

---

### **Reflection Questions:**

1. **What is insecure deserialization, and how can it be exploited?**
2. **How did you exploit the vulnerability in the vulnerable application?**
3. **How did the mitigations (switching to `json_decode` and validating input) prevent the exploitation?**
4. **Why is it important to restrict the types of objects that can be unserialized?**

---

### **Deliverables:**

For this assignment, submit the following:

1. **`vulnerable.php`** – The original file containing the insecure deserialization vulnerability.
2. **`vulnerable.php`** – The updated file with secure deserialization and validation.
3. **`README.md`** – A brief explanation of:
   - How insecure deserialization works and how it was exploited.
   - The changes you made to mitigate the vulnerability and secure the application.

---

### **Summary**

In this lab, you:
- Learned about Insecure Deserialization and how attackers can exploit this vulnerability to inject malicious objects.
- Exploited an insecure deserialization vulnerability by injecting malicious serialized data.
- Implemented secure deserialization practices, such as using `json_decode` and validating the data structure to prevent exploitation.

---