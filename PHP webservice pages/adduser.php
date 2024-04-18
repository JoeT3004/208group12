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

$con = mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);

if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
    exit();
}

if (!isset($username, $firstname, $lastname, $password)) {
    echo 'Please fill the registration form!';
    exit();
}

$checkname = "SELECT Username FROM Users WHERE Username = ?";

if ($stmt = $con->prepare($checkname)) {
    $stmt->bind_param('s', $username);
    $stmt->execute();
    $stmt->store_result();
    
    if ($stmt->num_rows > 0) {
        echo 'Username exists, please choose another!';
    } else {
        $newuser = "INSERT INTO Users (Username, FirstName, LastName, Password) VALUES (?, ?, ?, ?)";

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

mysqli_close($con);
?>
