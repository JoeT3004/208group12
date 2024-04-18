<?php

session_start();

$DATABASE_HOST = 'studdb.csc.liv.ac.uk';
$DATABASE_USER = 'sgtbrett';
$DATABASE_PASS = '';
$DATABASE_NAME = 'sgtbrett';

$username = $_GET['username'];
$id = $_GET['id'];
$score = $_GET['score'];

// Create connection
$con=mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

if ( !isset($username, $id, $score) ) {
        // Couldn't access the registration info
        exit('Data not entered');
}

$checkexists = "SELECT Username, QuizID FROM UserScore WHERE Username=? AND QuizID=?";

// check if the user has attempted this quiz before.
if ($stmt = $con->prepare($checkexists)) {

        $stmt->bind_param('si', $username, $id);
        $stmt->execute();
        $stmt->store_result();
        // Store the result so we can check if the record exists in the database.
        if ($stmt->num_rows > 0) {
                // removes old records of the user's attempts on that quiz before adding a new one
                $removeold = "DELETE FROM UserScore WHERE Username=? AND QuizID=?";

                if ($stmt = $con->prepare($removeold)) {
                        $stmt->bind_param('si', $username, $id);
                        $stmt->execute();
                } else {
                        exit("Couldn't remove old record");
                }
        }

        // adds the new attempt score to the database
        $newscore = "INSERT INTO UserScore VALUES (?, ?, ?)";

        if ($stmt = $con->prepare($newscore)) {
                $stmt->bind_param('sii', $username, $id, $score);
                $stmt->execute();
                echo 'Successfully added new attempt';
        } else {
                echo 'SQL Statement Failed';
        }

        $stmt->close();
} else {
        echo 'SQL Statement Failed';
}

// Close connections
mysqli_close($con);
?>
