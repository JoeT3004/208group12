<?php

session_start();

$DATABASE_HOST = 'studdb.csc.liv.ac.uk';
$DATABASE_USER = 'sgtbrett';
$DATABASE_PASS = '';
$DATABASE_NAME = 'sgtbrett';

$inusername = $_GET['username'];
$inpassword = $_GET['password'];

// Create connection
$con=mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

if ( !isset($inusername, $inpassword) ) {
        // Couldn't access the username and/or password
        exit('Please fill both the username and password fields!');
}



// searches the users table for a user with a matching username
$sql = "SELECT Username, FirstName, LastName, Password FROM Users WHERE Username=?";

// Check if there are results
if ($stmt = $con->prepare($sql))
{
        // If so, then create a results array and a temporary one
        // to hold the data
        $stmt->bind_param('s', $inusername);
        $stmt->execute();

        $stmt->store_result();

        if ($stmt->num_rows > 0) {
                $stmt->bind_result($username, $firstname, $lastname, $password);
                $stmt->fetch();

                // Account exists, now we verify the password.
                // Note: remember to use password_hash in your registration file to store the hashed passwords.

                if (password_verify($inpassword, $password)) {
                // if ($inpassword === $password) {
                        // Verification success! User has logged-in!
                        // Create sessions, so we know the user is logged in, they basically act like cookies but remem$                        session_regenerate_id();
                        $_SESSION['loggedin'] = TRUE;
                        $_SESSION['username'] = $username;

                        $row = array($username, $firstname, $lastname);
                        echo json_encode($row);
                        // $_SESSION['id'] = $id;
                        // echo $username . ',' . $firstname . ',' . $lastname;
                } else {
                        // Incorrect password
                        echo 'Incorrect username and/or password!';
                }
        } else {
                // Incorrect username
                echo 'Incorrect username and/or password!';
        }
}
else {
        echo "SQL Statement Failed";
}

// Close connections
mysqli_close($con);
?>
