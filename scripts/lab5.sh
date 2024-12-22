#!/bin/bash

# Variables
APP_NAME="Lab5_BrokenAccessControl"
APP_DIR="/opt/lampp/htdocs/$APP_NAME"

# Check if XAMPP is running, if not, start it
if ! pgrep -x "httpd" > /dev/null; then
    echo "Apache is not running. Starting XAMPP Apache server..."
    sudo /opt/lampp/lampp startapache
else
    echo "Apache server is already running."
fi

if ! pgrep -x "mysqld" > /dev/null; then
    echo "MySQL is not running. Starting XAMPP MySQL server..."
    sudo /opt/lampp/lampp startmysql
else
    echo "MySQL server is already running."
fi

# Create the application directory
echo "Creating the application directory at $APP_DIR"
mkdir -p "$APP_DIR"

# Create login.php (login page for users to authenticate)
cat <<EOL > "$APP_DIR/login.php"
<?php
session_start();

if (\$_SERVER['REQUEST_METHOD'] == 'POST') {
    \$username = \$_POST['username'];
    \$password = \$_POST['password'];

    // Hardcoded username and password
    if (\$username == 'admin' && \$password == 'admin123') {
        \$_SESSION['username'] = 'admin';
        header("Location: admin_dashboard.php");
    } elseif (\$username == 'user' && \$password == 'user123') {
        \$_SESSION['username'] = 'user';
        header("Location: user_dashboard.php");
    } else {
        echo "<p>Invalid credentials</p>";
    }
}
?>

<form action="login.php" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required><br>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required><br>
    <button type="submit">Login</button>
</form>
EOL

# Create admin_dashboard.php (admin dashboard with broken access control)
cat <<EOL > "$APP_DIR/admin_dashboard.php"
<?php
session_start();

// Simulate a logged-in user
\$_SESSION['username'] = 'user';  // Change this to 'admin' to simulate an admin login

if (!isset(\$_SESSION['username'])) {
    header("Location: login.php");
    exit();
}

echo "<h2>Welcome to the Admin Dashboard</h2>";
echo "<p>This is a secret admin page!</p>";
?>

<a href="user_dashboard.php">Go to User Dashboard</a>
EOL

# Create user_dashboard.php (user dashboard page)
cat <<EOL > "$APP_DIR/user_dashboard.php"
<?php
session_start();

// Simulate a logged-in user
\$_SESSION['username'] = 'user';  // You can modify this to simulate admin or other users

if (!isset(\$_SESSION['username'])) {
    header("Location: login.php");
    exit();
}

echo "<h2>Welcome to the User Dashboard</h2>";
echo "<p>This page is for regular users.</p>";
?>

<a href="admin_dashboard.php">Go to Admin Dashboard</a>
EOL

# Modify admin_dashboard.php (fix Broken Access Control)
cat <<EOL > "$APP_DIR/admin_dashboard.php"
<?php
session_start();

if (!isset(\$_SESSION['username'])) {
    header("Location: login.php");
    exit();
}

// Check if the user is an admin
if (\$_SESSION['username'] !== 'admin') {
    echo "<p>Access denied. You are not authorized to view this page.</p>";
    exit();
}

echo "<h2>Welcome to the Admin Dashboard</h2>";
echo "<p>This is a secret admin page!</p>";
?>
EOL

# Modify user_dashboard.php (ensures it can only be accessed by logged-in users)
cat <<EOL > "$APP_DIR/user_dashboard.php"
<?php
session_start();

if (!isset(\$_SESSION['username'])) {
    header("Location: login.php");
    exit();
}

echo "<h2>Welcome to the User Dashboard</h2>";
echo "<p>This page is for regular users.</p>";
?>
EOL

# Permissions for web server
echo "Setting permissions for the application files..."
sudo chown -R www-data:www-data "$APP_DIR"
sudo chmod -R 755 "$APP_DIR"

# Wait for XAMPP to start Apache and MySQL if not already running
sleep 2

# Provide instructions
echo ""
echo "Broken Access Control web application has been set up successfully!"
echo "You can access the vulnerable site by visiting http://localhost/$APP_NAME"
echo "To exploit the broken access control vulnerability, follow these steps:"
echo "1. Login as a regular user with username 'user' and password 'user123'."
echo "2. Try accessing the admin dashboard by changing the URL to: http://localhost/$APP_NAME/admin_dashboard.php"
echo "You will notice that you can access the admin page without proper authorization, demonstrating a Broken Access Control vulnerability."
echo ""
echo "To test the mitigated version:"
echo "1. Login as 'user' and try to access the admin page. You will see an 'Access Denied' message."
echo "2. Login as 'admin' and access the admin dashboard."

echo "Setup completed successfully!"
