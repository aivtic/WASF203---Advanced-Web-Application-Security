

### **Lab 14: Session Hijacking and Mitigation**

#### **Objective:**
In this lab, you will:
1. Understand how session hijacking attacks work.
2. Simulate a session hijacking attack.
3. Implement security measures to prevent session hijacking.

---

### **Task 1: Simulate Session Hijacking**

#### **Step 1: Create a Simple Login System**

1. Create a new folder for this lab, for example, `Lab16_Session_Hijacking`.

2. Inside this folder, create a file called `login.php` where the user can log in with a username and password. The application will use PHP sessions to store login data.

Example `login.php`:

```php
<?php
session_start();

$users = [
    'admin' => 'password123',
    'user1' => 'password456'
];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Check if the username and password match
    if (isset($users[$username]) && $users[$username] === $password) {
        $_SESSION['username'] = $username;
        echo "<h1>Welcome, " . $username . "!</h1>";
        echo "<a href='profile.php'>Go to Profile</a>";
    } else {
        echo "<h1>Invalid credentials!</h1>";
    }
}
?>

<form method="POST">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required><br>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required><br>
    <button type="submit">Login</button>
</form>
```

#### **Step 2: Create a Profile Page**

Create a file called `profile.php` to simulate the user's profile page, which can only be accessed after logging in.

Example `profile.php`:

```php
<?php
session_start();

if (!isset($_SESSION['username'])) {
    echo "<h1>You must log in to view your profile!</h1>";
    echo "<a href='login.php'>Login</a>";
} else {
    echo "<h1>Welcome to your profile, " . $_SESSION['username'] . "!</h1>";
    echo "<a href='logout.php'>Logout</a>";
}
?>
```

#### **Step 3: Simulate Session Hijacking**

1. Open `login.php` in a browser and log in with any user (e.g., `admin` with `password123`).
2. After logging in, copy the **Session ID** from your browser's cookies (usually found in Developer Tools → Application → Cookies).
3. Open an Incognito window in your browser or a different browser.
4. In the new window, manually set the Session ID (using the copied session ID) in the cookies to simulate hijacking the session.
5. Navigate to `profile.php` in the new window. If successful, you should now have access to the original user's profile without having logged in.

This demonstrates how an attacker can hijack a session by stealing the session ID, which is stored in cookies and used to authenticate the user.

---

### **Task 2: Mitigate Session Hijacking**

#### **Step 1: Implement Session Security Measures**

1. **Use `secure` and `HttpOnly` flags for cookies**: These flags ensure that the session cookie is only sent over secure HTTPS connections and cannot be accessed by JavaScript, reducing the risk of session hijacking.

In your `login.php` file, set the session cookie flags when starting the session:

```php
<?php
session_set_cookie_params([
    'lifetime' => 0, 
    'path' => '/', 
    'domain' => '', 
    'secure' => true, // Ensures cookie is sent only over HTTPS
    'httponly' => true, // Makes cookie inaccessible to JavaScript
    'samesite' => 'Strict' // Prevents cross-site request forgery
]);

session_start();

// Existing login code...
```

2. **Regenerate Session ID After Login**: To prevent session fixation (where the attacker can force the session ID), regenerate the session ID after the user successfully logs in:

```php
<?php
session_start();

// Regenerate the session ID
session_regenerate_id(true);

// Existing login code...
```

3. **Set a Session Timeout**: To ensure that sessions are not valid indefinitely, set a timeout for sessions. You can configure this in your `php.ini` or manage it programmatically by checking the session time.

```php
<?php
session_start();

// Set session timeout duration (e.g., 15 minutes)
$timeout_duration = 900; // 15 minutes

if (isset($_SESSION['last_activity']) && (time() - $_SESSION['last_activity']) > $timeout_duration) {
    session_unset();     // Unset session variables
    session_destroy();   // Destroy the session
    echo "<h1>Your session has expired. Please log in again.</h1>";
} else {
    $_SESSION['last_activity'] = time(); // Update last activity time
}

// Existing profile code...
```

4. **Use HTTPS**: Ensure that the website uses HTTPS to encrypt all communication, including the session cookie, to prevent man-in-the-middle attacks.

---

### **Task 3: Test the Mitigation Measures**

1. **Test Session Hijacking**: After implementing the security measures, repeat the session hijacking test by copying the session ID from one browser and setting it in another browser.
   - **Expected Result**: The session hijacking attempt should fail because the session ID is now regenerated after login, and the `secure` and `HttpOnly` flags will prevent the cookie from being accessed or sent over an insecure connection.

2. **Test Session Timeout**: Log in and leave the session idle for longer than the configured timeout (e.g., 15 minutes).
   - **Expected Result**: The session should expire automatically, and you'll need to log in again.

---

### **Reflection Questions:**

1. **How does session hijacking work, and why is it a critical vulnerability?**
2. **What security measures did you implement to mitigate session hijacking?**
3. **Why is it important to use secure flags for cookies and regenerate the session ID after login?**

---

### **Deliverables:**

For this assignment, submit the following:

1. **`login.php`** – The file with the original session hijacking vulnerability.
2. **`login.php`** – The updated file with session hijacking mitigations (e.g., `secure`, `HttpOnly` flags, session regeneration).
3. **`profile.php`** – The user profile page.
4. **`README.md`** – A brief explanation of:
   - How session hijacking works and how it was simulated.
   - The security measures implemented to mitigate the risk.
   - Testing results showing that session hijacking was prevented.

---

### **Summary**

In this lab, you:
- Simulated a session hijacking attack and exploited it to access another user's session.
- Implemented several session security best practices, including regenerating session IDs, using `secure` and `HttpOnly` cookies, and setting session timeouts.
- Tested the mitigation measures to ensure that session hijacking could not be exploited.

---

Let me know if you're ready to move to the next lab or need more details!