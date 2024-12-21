

## **Advanced SQL Injection Lab**

### **Objective:**
This lab will cover advanced SQL injection techniques including:
- **Error-based SQL injection**
- **Time-based Blind SQL injection**
- **Second-order SQL injection**
Students will exploit vulnerabilities in a web application, then apply mitigation strategies using secure coding practices.

---

### **Lab Requirements:**
- **Web Server**: A local server setup such as XAMPP, WAMP, or LAMP (with PHP & MySQL).
- **Database**: A MySQL database with user authentication and product management.
- **Basic Knowledge**: Students should have a basic understanding of SQL, PHP, and SQL injection techniques.

---

### **Step 1: Setting up the Environment**

1. **Install a Local Server**
   - Install **XAMPP** (https://www.apachefriends.org/index.html) or **WAMP** (http://www.wampserver.com/en/) or **LAMP** on your local machine.
   - Ensure Apache, MySQL, and PHP are running.

2. **Create a Database**
   Open **phpMyAdmin** (http://localhost/phpmyadmin) and execute the following SQL queries to create the database and tables:

   ```sql
   CREATE DATABASE vulnerable_db;

   USE vulnerable_db;

   -- Create Users Table
   CREATE TABLE users (
       id INT(11) AUTO_INCREMENT PRIMARY KEY,
       username VARCHAR(50) NOT NULL,
       password VARCHAR(255) NOT NULL
   );

   -- Insert Sample Users
   INSERT INTO users (username, password) VALUES 
   ('admin', 'admin123'), 
   ('user', 'user123');

   -- Create Products Table
   CREATE TABLE products (
       id INT(11) AUTO_INCREMENT PRIMARY KEY,
       name VARCHAR(100) NOT NULL,
       description TEXT
   );

   -- Insert Sample Products
   INSERT INTO products (name, description) VALUES
   ('Product 1', 'Description of Product 1'),
   ('Product 2', 'Description of Product 2'),
   ('Product 3', 'Description of Product 3');
   ```

---

### **Step 2: Vulnerable Application Code**

1. **Create the Folder for the Application**
   Create a folder named `vulnerable_app` in the `htdocs` (for XAMPP) or `www` (for WAMP) directory.

2. **Application Files:**
   - `config.php`: Database connection.
   - `db.php`: Contains database queries.
   - `index.php`: Home page with links.
   - `register.php`: User registration form.
   - `login.php`: User login form.
   - `search.php`: Search products page.

---

#### **config.php** (Database Connection)

```php
<?php
$servername = "localhost"; // MySQL server address
$username = "root"; // MySQL username (default for XAMPP is "root")
$password = ""; // MySQL password (default for XAMPP is "")
$dbname = "vulnerable_db"; // Database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
```

#### **db.php** (Database Queries)

```php
<?php
include 'config.php';

// Function to retrieve users based on the username (vulnerable to SQL injection)
function get_user($username) {
    global $conn;
    $sql = "SELECT * FROM users WHERE username = '$username'";  // Vulnerable to SQL injection
    $result = $conn->query($sql);
    return $result;
}

// Function to search for products (vulnerable to SQL injection)
function get_products($search) {
    global $conn;
    $sql = "SELECT * FROM products WHERE name LIKE '%$search%'"; // Vulnerable to SQL injection
    $result = $conn->query($sql);
    return $result;
}
?>
```

#### **index.php** (Home Page)

```php
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vulnerable Web Application</title>
</head>
<body>
    <h1>Welcome to the Vulnerable Web Application</h1>
    <p><a href="register.php">Register</a> | <a href="login.php">Login</a> | <a href="search.php">Search Products</a></p>
</body>
</html>
```

#### **register.php** (User Registration - Vulnerable to Second-order SQL Injection)

```php
<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Vulnerable to Second-order SQL Injection
    $sql = "INSERT INTO users (username, password) VALUES ('$username', '$password')";
    
    if ($conn->query($sql) === TRUE) {
        echo "Registration successful!";
    } else {
        echo "Error: " . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
</head>
<body>
    <h1>Register</h1>
    <form action="register.php" method="POST">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" required><br><br>
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required><br><br>
        <button type="submit">Register</button>
    </form>
</body>
</html>
```

#### **login.php** (Login - Vulnerable to Time-based Blind SQL Injection)

```php
<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Vulnerable to Time-based Blind SQL Injection
    $result = get_user($username);

    if ($result && $result->num_rows > 0) {
        $row = $result->fetch_assoc();
        // Assuming passwords are stored in plaintext (for testing purposes)
        if ($row['password'] == $password) {
            echo "Login successful!";
        } else {
            echo "Invalid credentials.";
        }
    } else {
        echo "No user found with that username.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
</head>
<body>
    <h1>Login</h1>
    <form action="login.php" method="POST">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" required><br><br>
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required><br><br>
        <button type="submit">Login</button>
    </form>
</body>
</html>
```

#### **search.php** (Search - Vulnerable to Error-based SQL Injection)

```php
<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['search'])) {
    $search = $_GET['search'];

    // Vulnerable to Error-based SQL Injection
    $result = get_products($search);
    
    if ($result && $result->num_rows > 0) {
        echo "<h3>Search Results:</h3>";
        while ($row = $result->fetch_assoc()) {
            echo "Product: " . $row['name'] . "<br>";
            echo "Description: " . $row['description'] . "<br><br>";
        }
    } else {
        echo "No products found.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Products</title>
</head>
<body>
    <h1>Search for Products</h1>
    <form action="search.php" method="GET">
        <label for="search">Search:</label>
        <input type="text" name="search" id="search" required><br><br>
        <button type="submit">Search</button>
    </form>
</body>
</html>
```

---

### **Step 3: Exploit SQL Injection Vulnerabilities**

#### **1. Error-based SQL Injection**
- Go to **search.php** and enter this payload into the search box: `' UNION SELECT NULL, NULL, NULL --`.
- This should trigger a SQL error or data leakage if the application is improperly handling SQL errors.

#### **2. Time-based Blind SQL Injection**
- Go to **login.php** and try entering this payload into the username field: `' OR SLEEP(

5) --`.
- The page will delay for 5 seconds if the injection is successful.

#### **3. Second-order SQL Injection**
- Go to **register.php** and try this payload: `admin' --` in the username field.
- Log in with `admin' --` as the username and observe that the application fails to properly filter input data.

---

### **Step 4: Mitigation**

#### **1. Use Prepared Statements (to prevent SQL Injection)**
For **login.php**, modify the database query to use prepared statements instead of direct SQL.

```php
// Use prepared statements for SQL queries
$stmt = $conn->prepare("SELECT * FROM users WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();
```

#### **2. Validate Inputs (to prevent SQL Injection)**
For **register.php**, validate and sanitize input data:

```php
$username = mysqli_real_escape_string($conn, $_POST['username']);
$password = mysqli_real_escape_string($conn, $_POST['password']);
```

#### **3. Error Handling (to prevent information leakage)**
For **config.php**, disable error reporting:

```php
ini_set('display_errors', 0);
```

---

### **Conclusion**

This lab exposed students to various **advanced SQL injection techniques** including **error-based**, **time-based blind**, and **second-order SQL injection**. They then learned how to **mitigate** these vulnerabilities using **prepared statements**, **input validation**, and **error handling**.

This comprehensive approach will enhance students' understanding of real-world vulnerabilities and how to fix them effectively.

---
