#!/bin/bash

# Check if XAMPP is installed
if ! command -v xampp &> /dev/null
then
    echo "XAMPP could not be found. Please install XAMPP first."
    exit 1
fi

# Define paths for the application and database setup
XAMPP_PATH="/opt/lampp"
DOCUMENT_ROOT="$XAMPP_PATH/htdocs"
APP_NAME="vulnerable_app"
DB_NAME="vulnerable_db"
DB_USER="root"
DB_PASS=""

# Create a directory for the web application
echo "Creating the vulnerable web application directory..."
mkdir -p "$DOCUMENT_ROOT/$APP_NAME"

# Step 1: Set up the database
echo "Setting up the MySQL database..."

# SQL commands to create the database and tables
SQL_COMMANDS="
CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

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
"

# Execute the SQL commands using MySQL (without password)
echo "$SQL_COMMANDS" | sudo "$XAMPP_PATH/bin/mysql" -u "$DB_USER" -p"$DB_PASS"

# Step 2: Create the vulnerable PHP files for the app
echo "Creating the PHP files for the web application..."

# Create the index.php file
cat <<EOL > "$DOCUMENT_ROOT/$APP_NAME/index.php"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vulnerable Web Application</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Welcome to the Vulnerable Web Application</h1>
        <p><a href="register.php">Register</a> | <a href="login.php">Login</a> | <a href="search.php">Search Products</a></p>
    </div>
</body>
</html>
EOL

# Create the config.php file
cat <<EOL > "$DOCUMENT_ROOT/$APP_NAME/config.php"
<?php
\$servername = "localhost";
\$username = "root";
\$password = "";
\$dbname = "vulnerable_db";

\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);
if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
}
?>
EOL

# Create the db.php file
cat <<EOL > "$DOCUMENT_ROOT/$APP_NAME/db.php"
<?php
include 'config.php';

function get_user(\$username) {
    global \$conn;
    \$sql = "SELECT * FROM users WHERE username = '\$username'";  // Vulnerable to SQL injection
    \$result = \$conn->query(\$sql);
    return \$result;
}

function get_products(\$search) {
    global \$conn;
    \$sql = "SELECT * FROM products WHERE name LIKE '%\$search%'";  // Vulnerable to SQL injection
    \$result = \$conn->query(\$sql);
    return \$result;
}
?>
EOL

# Create the register.php file
cat <<EOL > "$DOCUMENT_ROOT/$APP_NAME/register.php"
<?php
include 'db.php';

if (\$_SERVER['REQUEST_METHOD'] == 'POST') {
    \$username = \$_POST['username'];
    \$password = \$_POST['password'];

    \$sql = "INSERT INTO users (username, password) VALUES ('\$username', '\$password')";  // Vulnerable to SQL injection
    
    if (\$conn->query(\$sql) === TRUE) {
        echo "Registration successful!";
    } else {
        echo "Error: " . \$conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Register</h1>
        <form action="register.php" method="POST">
            <label for="username">Username:</label>
            <input type="text" name="username" id="username" required><br><br>
            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required><br><br>
            <button type="submit">Register</button>
        </form>
    </div>
</body>
</html>
EOL

# Create the login.php file
cat <<EOL > "$DOCUMENT_ROOT/$APP_NAME/login.php"
<?php
include 'db.php';

if (\$_SERVER['REQUEST_METHOD'] == 'POST') {
    \$username = \$_POST['username'];
    \$password = \$_POST['password'];

    \$result = get_user(\$username);

    if (\$result && \$result->num_rows > 0) {
        \$row = \$result->fetch_assoc();
        if (\$row['password'] == \$password) {
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
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Login</h1>
        <form action="login.php" method="POST">
            <label for="username">Username:</label>
            <input type="text" name="username" id="username" required><br><br>
            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required><br><br>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
EOL

# Create the search.php file
cat <<EOL > "$DOCUMENT_ROOT/$APP_NAME/search.php"
<?php
include 'db.php';

if (\$_SERVER['REQUEST_METHOD'] == 'GET' && isset(\$_GET['search'])) {
    \$search = \$_GET['search'];

    \$result = get_products(\$search);
    
    if (\$result && \$result->num_rows > 0) {
        echo "<h3>Search Results:</h3>";
        while (\$row = \$result->fetch_assoc()) {
            echo "Product: " . \$row['name'] . "<br>";
            echo "Description: " . \$row['description'] . "<br><br>";
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
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Search for Products</h1>
        <form action="search.php" method="GET">
            <label for="search">Search:</label>
            <input type="text" name="search" id="search" required><br><br>
            <button type="submit">Search</button>
        </form>
    </div>
</body>
</html>
EOL

# Create the style.css file
cat <<EOL > "$DOCUMENT_ROOT/$APP_NAME/style.css"
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

.container {
    width: 80%;
    max-width: 800px;
    margin: 20px auto;
    padding: 20px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

h1 {
    text-align: center;
    color: #333;
}

form {
    display: flex;
    flex-direction: column;
    align-items: center;
}

label {
    margin-bottom: 8px;
    color: #555;
}

input[type="text"], input[type="password"] {
    width: 100%;
    padding: 10px;
    margin-bottom: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

button {
    padding: 10px 20px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

button:hover {
    background-color: #45a049;
}

a {
    color: #007BFF;
    text-decoration: none;
    margin: 0 10px;
}

a:hover {
    text-decoration: underline;
}
EOL

echo "Web application setup complete!"
