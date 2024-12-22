#!/bin/bash

# This script will set up the Advanced SQL Injection Lab environment for XAMPP on Linux.

# 1. Setup the MySQL Database and Tables
echo "Setting up the database and tables..."
/opt/lampp/bin/mysql -u root -e "CREATE DATABASE IF NOT EXISTS vulnerable_db;"

# Use the newly created database
/opt/lampp/bin/mysql -u root vulnerable_db <<EOF
-- Create Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Insert Sample Users
INSERT INTO users (username, password) VALUES 
('admin', 'admin123'), 
('user', 'user123');

-- Create Products Table
CREATE TABLE IF NOT EXISTS products (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Insert Sample Products
INSERT INTO products (name, description) VALUES
('Product 1', 'Description of Product 1'),
('Product 2', 'Description of Product 2'),
('Product 3', 'Description of Product 3');
EOF

echo "Database setup complete!"

# 2. Create the vulnerable application folder in XAMPP's htdocs directory
echo "Setting up the application folder..."
APP_DIR="/opt/lampp/htdocs/vulnerable_app"

# Create the application folder if it doesn't exist
mkdir -p $APP_DIR

# 3. Create and populate application files

# Create config.php (Database Connection)
cat << 'EOF' > $APP_DIR/config.php
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
EOF

# Create db.php (Database Queries)
cat << 'EOF' > $APP_DIR/db.php
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
EOF

# Create index.php (Home Page)
cat << 'EOF' > $APP_DIR/index.php
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
EOF

# Create register.php (User Registration - Vulnerable to Second-order SQL Injection)
cat << 'EOF' > $APP_DIR/register.php
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
EOF

# Create login.php (Login - Vulnerable to Time-based Blind SQL Injection)
cat << 'EOF' > $APP_DIR/login.php
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
EOF

# Create search.php (Search - Vulnerable to Error-based SQL Injection)
cat << 'EOF' > $APP_DIR/search.php
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
EOF

echo "Application setup complete! The vulnerable app is located at: /opt/lampp/htdocs/vulnerable_app"

# 4. Instructions
echo "Setup complete. You can now open your browser and visit:"
echo "http://localhost/vulnerable_app/index.php"
