<?php

$DATABASE_HOST = 'studdb.csc.liv.ac.uk';
$DATABASE_USER = 'sgtbrett';
$DATABASE_PASS = '';
$DATABASE_NAME = 'sgtbrett';

$intype = $_GET['type'];

// Create connection
$con=mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

if (!isset($intype)) {
        exit('No data entered!');
}

// searches the questions table for a question with a matching id
$sql = "SELECT QuizID, Name, Type FROM Quizzes WHERE Type=?";

// Check if there are results
if ($stmt = $con->prepare($sql))
{
        $stmt->bind_param('s', $intype);
        // If so, then create a results array and a temporary one
        // to hold the data
        $stmt->execute();

        $stmt->store_result();
        $resultArray = array();

        if ($stmt->num_rows > 0) {
                $stmt->bind_result($id, $name, $type);
                while($stmt->fetch())
                {
                        $tempArray = array($id, $name, $type);
                        array_push($resultArray, $tempArray);

                        $stmt->bind_result($id, $name, $type);
                }

        } else {
                // Incorrect id
                echo 'No quizzes to display';
        }
        echo json_encode($resultArray);
}
else {
        echo "SQL Statement Failed";
}

// Close connections
mysqli_close($con);
?>
