#!/bin/bash

# Lab folder setup
mkdir -p Lab17_Insecure_Deserialization
cd Lab17_Insecure_Deserialization

# Create the CSS file for styling
cat <<EOL > styles.css
/* styles.css */
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f9;
    color: #333;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.container {
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    width: 80%;
    max-width: 600px;
}

h1 {
    color: #4CAF50;
    text-align: center;
}

form {
    display: flex;
    flex-direction: column;
}

label {
    margin-bottom: 8px;
    font-size: 16px;
}

textarea {
    padding: 10px;
    margin-bottom: 20px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

button {
    padding: 10px;
    background-color: #4CAF50;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
}

button:hover {
    background-color: #45a049;
}

.error {
    color: #f44336;
    font-size: 16px;
    text-align: center;
}

.success {
    color: #4CAF50;
    font-size: 16px;
    text-align: center;
}
EOL

# Create the vulnerable.php file
cat <<'EOL' > vulnerable.php
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
        echo "<h1 class='success'>Welcome, " . $this->username . "!</h1>";
        echo "<p>Your role is: " . $this->role . "</p>";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insecure Deserialization - Vulnerable</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Vulnerable PHP Application</h1>

        <?php
        if (isset($_POST['serialized_data'])) {
            // Simulating unserialization from untrusted input
            $data = $_POST['serialized_data'];
            $user = unserialize($data);

            // Call the login method, which might be triggered on deserialization
            $user->login();
        } else {
            echo "<h2 class='error'>Please submit serialized data</h2>";
        }
        ?>

        <form method="POST">
            <label for="serialized_data">Serialized Data:</label><br>
            <textarea id="serialized_data" name="serialized_data" rows="5" cols="40"></textarea><br>
            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>
EOL

# Create the fixed.php file (with safe deserialization)
cat <<'EOL' > fixed.php
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
        echo "<h1 class='success'>Welcome, " . $this->username . "!</h1>";
        echo "<p>Your role is: " . $this->role . "</p>";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insecure Deserialization - Fixed</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Fixed PHP Application</h1>

        <?php
        if (isset($_POST['json_data'])) {
            // Secure deserialization using json_decode
            $data = json_decode($_POST['json_data'], true);

            // Make sure the data structure is validated before usage
            if (isset($data['username']) && isset($data['role'])) {
                $user = new User($data['username'], $data['role']);
                $user->login();
            } else {
                echo "<h2 class='error'>Invalid Data</h2>";
            }
        } else {
            echo "<h2 class='error'>Please submit JSON data</h2>";
        }
        ?>

        <form method="POST">
            <label for="json_data">JSON Data:</label><br>
            <textarea id="json_data" name="json_data" rows="5" cols="40"></textarea><br>
            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>
EOL

# Provide instructions to run the PHP server
echo "Lab setup is complete!"
echo "1. To test the vulnerable PHP app, open the following URL in your browser:"
echo "   http://localhost:8000/Lab17_Insecure_Deserialization/vulnerable.php"
echo "2. To test the fixed PHP app, open the following URL in your browser:"
echo "   http://localhost:8000/Lab17_Insecure_Deserialization/fixed.php"
echo "3. To start the PHP server, run the following command:"
echo "   php -S localhost:8000 -t Lab17_Insecure_Deserialization"
