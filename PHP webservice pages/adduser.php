<?php

session_start();

$DATABASE_HOST = 'studdb.csc.liv.ac.uk';
$DATABASE_USER = 'sgtbrett';
$DATABASE_PASS = '';
$DATABASE_NAME = 'sgtbrett';

$username = $_GET['username'];
$firstname = $_GET['firstname'];
$lastname = $_GET['lastname'];
$password = $_GET['password'];

// Create connection
$con=mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

if ( !isset($username, $firstname, $lastname, $password) ) {
        // Couldn't access the registration info
        exit('Please fill the registration form!');
}

$checkname = "SELECT Username, Password FROM Users WHERE Username=?";

// We need to check if the account with that username exists.
if ($stmt = $con->prepare($checkname)) {

        $stmt->bind_param('s', $username);
        $stmt->execute();
        $stmt->store_result();
        // Store the result so we can check if the account exists in the database.
        if ($stmt->num_rows > 0) {
                // Username already exists
                echo 'Username exists, please choose another!';
        } else {

                $newuser = "INSERT INTO Users VALUES (?, ?, ?, ?)";

                if ($stmt = $con->prepare($newuser)) {
                        $passwordhash = password_hash($password, PASSWORD_DEFAULT);
                        $stmt->bind_param('ssss', $username, $firstname, $lastname, $passwordhash);
                        $stmt->execute();
                        echo 'Registration successful';
                } else {
                        echo 'SQL Statement Failed';
                }

        }
        $stmt->close();
} else {
        echo 'SQL Statement Failed';
}

// Close connections
mysqli_close($con);
?>
