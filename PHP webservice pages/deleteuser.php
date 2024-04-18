<?php

session_start();

$DATABASE_HOST = 'studdb.csc.liv.ac.uk';
$DATABASE_USER = 'sgtbrett';
$DATABASE_PASS = '';
$DATABASE_NAME = 'sgtbrett';

$inusername = $_SESSION['username'];

$inpassword = $_GET['password'];

// Create connection
$con=mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

if ( !isset($inpassword) ) {
        // Couldn't access the registration info
        exit('Could not read password');
}

if ( !isset($inusername) ) {
        // Couldn't access the registration info
        exit('Could not read username');
}

$checkname = "SELECT Password FROM Users WHERE Username=?";

// We need to check if the account with that username exists.
if ($stmt = $con->prepare($checkname)) {
        $stmt->bind_param('s', $inusername);
        $stmt->execute();

        $stmt->store_result();

        // $rows = $stmt->num_rows;
        if ($stmt->num_rows > 0) {
                $stmt->bind_result($password);
		$stmt->fetch();

                if (password_verify($inpassword, $password)) {
                        $removeuser = "DELETE FROM Users WHERE Username=?;";

                        if ($stmt = $con->prepare($removeuser)) {
                                $stmt->bind_param('s', $inusername);
                                $stmt->execute();
                                echo 'Account successfully deleted';
                        } else {
                                echo 'SQL Statement Failed';
                        }

                } else {
                        exit('Incorrect password');
                }
        } else {
                exit('User not found');
        }

        $stmt->close();
} else {
        echo 'SQL Statement Failed';
}

// Close connections
mysqli_close($con);
?>
				
