#!/bin/bash

# Variables
APP_NAME="Lab9_XSS"
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

# Create index.php (input form with CSS styling)
cat <<EOL > "$APP_DIR/index.php"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>XSS Vulnerability Example</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #4CAF50;
            color: white;
            padding: 10px 0;
            text-align: center;
        }
        .container {
            width: 60%;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        form {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }
        label {
            font-size: 16px;
            margin-bottom: 5px;
        }
        input[type="text"] {
            padding: 8px;
            font-size: 16px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <header>
        <h1>Cross-Site Scripting (XSS) Example</h1>
    </header>
    <div class="container">
        <h2>Enter your name:</h2>
        <form action="xss_form.php" method="post">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required><br>
            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>
EOL

# Create xss_form.php (vulnerable to XSS)
cat <<EOL > "$APP_DIR/xss_form.php"
<?php
if (\$_SERVER['REQUEST_METHOD'] == 'POST') {
    \$name = \$_POST['name'];  // Directly using user input without sanitizing

    // Vulnerability: XSS
    echo "<p>Hello, \$name!</p>";  // User input is directly displayed on the page without escaping
}
?>
EOL

# Create xss_form.php (mitigated version with htmlspecialchars)
cat <<EOL > "$APP_DIR/xss_form_mitigated.php"
<?php
if (\$_SERVER['REQUEST_METHOD'] == 'POST') {
    \$name = htmlspecialchars(\$_POST['name'], ENT_QUOTES, 'UTF-8');  // Sanitize user input

    echo "<p>Hello, \$name!</p>";  // Output the sanitized input
}
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
echo "Vulnerable XSS web application has been set up successfully!"
echo "You can access the vulnerable site by visiting http://localhost/$APP_NAME"
echo "To exploit the XSS vulnerability, enter the following payload in the 'name' field:"
echo "    <script>alert('XSS Attack!');</script>"
echo "You will see the alert message pop up, demonstrating the XSS attack."
echo ""
echo "To mitigate the vulnerability, you can apply the 'htmlspecialchars()' function in the xss_form.php file."

echo "Setup completed successfully!"
