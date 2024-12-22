#!/bin/bash

# Variables
APP_NAME="Lab2_HTMLInjection"
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

# Create index.html with CSS Styling
cat <<EOL > "$APP_DIR/index.html"
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HTML Injection Example</title>
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
            h2 {
                color: #333;
                font-size: 22px;
            }
            .alert {
                background-color: #f44336;
                color: white;
                padding: 20px;
                margin-top: 20px;
                border-radius: 4px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <header>
            <h1>HTML Injection Test</h1>
        </header>
        <div class="container">
            <h2>Enter your Name:</h2>
            <form action="server.php" method="post">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name">
                <button type="submit">Submit</button>
            </form>

            <?php
            if (isset(\$_POST['name'])) {
                echo "<h2>Hello, " . \$_POST['name'] . "!</h2>";
            }
            ?>
        </div>
    </body>
</html>
EOL

# Create server.php (vulnerable)
cat <<EOL > "$APP_DIR/server.php"
<?php
if (isset(\$_POST['name'])) {
    echo "<h2>Hello, " . \$_POST['name'] . "!</h2>";
}
?>
EOL

# Wait for XAMPP to start Apache and MySQL if not already running
sleep 2

# Provide instructions
echo ""
echo "Vulnerable web application has been set up successfully!"
echo "You can access the vulnerable site by visiting http://localhost/$APP_NAME"
echo "To exploit the HTML injection, enter the following payload in the 'Name' field:"
echo "<script>alert('Hacked!');</script>"
echo "You will see a pop-up showing 'Hacked!'"
echo ""
echo "To mitigate the vulnerability, you can apply input sanitization using htmlspecialchars()."
echo "Visit server.php to see the vulnerable and fixed versions of the code."

# Permissions for web server
echo "Setting permissions for the application files..."
sudo chown -R www-data:www-data "$APP_DIR"
sudo chmod -R 755 "$APP_DIR"

echo "Setup completed successfully!"
