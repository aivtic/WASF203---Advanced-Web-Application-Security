

### **Lab 13: Insecure Direct Object References (IDOR)**

#### **Objective:**
In this lab, you will:
1. Learn about Insecure Direct Object References (IDOR) vulnerabilities.
2. Identify and exploit IDOR vulnerabilities in a web application.
3. Implement proper access controls to prevent IDOR vulnerabilities.

---

### **Task 1: Simulate an IDOR Vulnerability**

#### **Step 1: Create a Simple PHP Application**

1. Create a new folder for this lab, for example, `Lab15_IDOR`.

2. Inside this folder, create a file called `profile.php` where the user can access their profile page by passing their user ID in the URL.

Example of `profile.php`:

```php
<?php
session_start();

// Simulated user data
$users = [
    1 => ['username' => 'john_doe', 'email' => 'john@example.com'],
    2 => ['username' => 'jane_smith', 'email' => 'jane@example.com'],
    3 => ['username' => 'bob_jones', 'email' => 'bob@example.com'],
];

// Simulate a user being logged in with ID 1
$_SESSION['user_id'] = 1;

// Get the user ID from the URL
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if ($user_id && isset($users[$user_id])) {
    // Display user profile
    echo "<h1>User Profile</h1>";
    echo "<p>Username: " . $users[$user_id]['username'] . "</p>";
    echo "<p>Email: " . $users[$user_id]['email'] . "</p>";
} else {
    echo "<h1>Invalid User ID</h1>";
}
?>
```

#### **Step 2: Simulate the Vulnerability**

1. Start the application by opening `profile.php` in a browser.
2. Access the profile of user 1 by navigating to `profile.php?user_id=1`.
3. Now, try accessing the profiles of users 2 and 3 by changing the URL:
   - `profile.php?user_id=2`
   - `profile.php?user_id=3`

In this scenario, a user can access the profiles of other users by directly manipulating the `user_id` parameter in the URL. This is an **Insecure Direct Object Reference (IDOR)** vulnerability because the application does not verify if the logged-in user is authorized to access the data of other users.

#### **Step 3: Exploit the IDOR Vulnerability**

As an attacker, you can now access other users' profiles simply by changing the `user_id` in the URL. For example:
- Accessing `profile.php?user_id=2` will show Jane's profile, even if you're logged in as John.
- Similarly, accessing `profile.php?user_id=3` will show Bob's profile.

---

### **Task 2: Fixing the IDOR Vulnerability**

#### **Step 1: Implement Access Control**

To fix the IDOR vulnerability, we need to implement access control to ensure that a user can only access their own data.

Modify the `profile.php` file to check if the logged-in user matches the `user_id` parameter. If not, deny access.

Updated `profile.php`:

```php
<?php
session_start();

// Simulated user data
$users = [
    1 => ['username' => 'john_doe', 'email' => 'john@example.com'],
    2 => ['username' => 'jane_smith', 'email' => 'jane@example.com'],
    3 => ['username' => 'bob_jones', 'email' => 'bob@example.com'],
];

// Simulate a user being logged in with ID 1
$_SESSION['user_id'] = 1;

// Get the user ID from the URL
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

// Check if the user is trying to access their own profile
if ($user_id && $user_id == $_SESSION['user_id'] && isset($users[$user_id])) {
    // Display user profile
    echo "<h1>User Profile</h1>";
    echo "<p>Username: " . $users[$user_id]['username'] . "</p>";
    echo "<p>Email: " . $users[$user_id]['email'] . "</p>";
} else {
    echo "<h1>Access Denied: You can only view your own profile.</h1>";
}
?>
```

#### **Step 2: Test the Fixed Application**

1. Now, try accessing the profile of other users:
   - `profile.php?user_id=1` – This should show your own profile (as the logged-in user).
   - `profile.php?user_id=2` – This should show "Access Denied" because you are not authorized to view Jane's profile.
   - `profile.php?user_id=3` – This should show "Access Denied" because you are not authorized to view Bob's profile.

---

### **Reflection Questions:**

1. **What is IDOR, and how can it impact a web application?**
2. **How did the lack of access control in the original code lead to an IDOR vulnerability?**
3. **How did you fix the vulnerability, and what security measure was implemented to prevent unauthorized access?**

---

### **Deliverables:**

For this assignment, submit the following:

1. **`profile.php`** – The original file containing the IDOR vulnerability.
2. **`profile.php`** – The updated file with the IDOR vulnerability fixed using access control.
3. **`README.md`** – A brief explanation of:
   - What IDOR vulnerabilities are and how they are exploited.
   - How you fixed the vulnerability by implementing access control.

---

### **Summary**

In this lab, you:
- Learned about Insecure Direct Object References (IDOR) and how attackers can exploit this vulnerability by manipulating parameters in the URL.
- Implemented access control to fix the IDOR vulnerability, ensuring that users can only access their own data.

---

Let me know if you're ready to proceed or if you need further details!