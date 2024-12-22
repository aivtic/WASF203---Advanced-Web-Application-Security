#!/bin/bash

# Variables
APP_NAME="Lab3_CommandInjection"
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
        <title>Command Injection Example</title>
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
            pre {
                background-color: #f1f1f1;
                padding: 10px;
                border-radius: 5px;
                font-family: "Courier New", monospace;
                white-space: pre-wrap;
            }
        </style>
    </head>
    <body>
        <header>
            <h1>Command Injection Test</h1>
        </header>
        <div class="container">
            <h2>Enter a domain or IP address:</h2>
            <form action="command.php" method="post">
                <label for="domain">Domain/IP:</label>
                <input type="text" id="domain" name="domain">
                <button type="submit">Submit</button>
            </form>

            <?php
            if (isset(\$_POST['domain'])) {
                echo "<h2>Results:</h2>";
                \$domain = \$_POST['domain'];

                // Vulnerable to command injection
                \$output = shell_exec("ping -c 4 " . \$domain); // Linux command
                echo "<pre>\$output</pre>";
            }
            ?>
        </div>
    </body>
</html>
EOL

# Create command.php (vulnerable)
cat <<EOL > "$APP_DIR/command.php"
<?php
if (isset(\$_POST['domain'])) {
    \$domain = \$_POST['domain'];

    // Vulnerable to command injection: directly using user input in system command
    \$output = shell_exec("ping -c 4 " . \$domain); // Linux command
    echo "<pre>\$output</pre>";
}
?>
EOL

# Create command.php (mitigated)
cat <<EOL > "$APP_DIR/command_mitigated.php"
<?php
if (isset(\$_POST['domain'])) {
    \$domain = \$_POST['domain'];

    // Mitigate the command injection vulnerability
    \$safe_domain = escapeshellcmd(\$domain);

    // Safely execute the ping command
    \$output = shell_exec("ping -c 4 " . \$safe_domain); // Linux command
    echo "<pre>\$output</pre>";
}
?>
EOL

# Wait for XAMPP to start Apache and MySQL if not already running
sleep 2

# Provide instructions
echo ""
echo "Vulnerable web application has been set up successfully!"
echo "You can access the vulnerable site by visiting http://localhost/$APP_NAME"
echo "To exploit the command injection, enter the following payload in the 'domain' field:"
echo "example.com; ls -la"
echo "You will see the result of the ping command followed by the directory listing"
echo ""
echo "To mitigate the vulnerability, you can apply the 'escapeshellcmd()' function in the command.php file."

# Permissions for web server
echo "Setting permissions for the application files..."
sudo chown -R www-data:www-data "$APP_DIR"
sudo chmod -R 755 "$APP_DIR"

echo "Setup completed successfully!"
