<?php
session_start();

$DATABASE_HOST = 'studdb.csc.liv.ac.uk';
$DATABASE_USER = 'sgtbrett';
$DATABASE_PASS = '';
$DATABASE_NAME = 'sgtbrett';

$username = $_SESSION['username'];
$id = $_GET['id'];

// Create connection
$con=mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

if ( !isset($username, $id) ) {
        // Couldn't access the id/username
        exit('Inaccessible data');
}



// searches the scores table for a record with matching data
$sql = "SELECT Score FROM UserScore WHERE Username=? AND QuizID=?";

// Check if there are results
if ($stmt = $con->prepare($sql))
{
        // If so, then create a results array and a temporary one
        // to hold the data
        $stmt->bind_param('si', $username, $id);
        $stmt->execute();

        $stmt->store_result();

        if ($stmt->num_rows > 0) {
                $stmt->bind_result($score);
                $stmt->fetch();

                echo $score;
          
        } else {
                // Incorrect id
                echo '0';
        }
}
else {
        echo "SQL Statement Failed";
}

// Close connections
mysqli_close($con);
?>
