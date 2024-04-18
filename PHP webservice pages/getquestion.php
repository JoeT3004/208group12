<?php

$DATABASE_HOST = 'studdb.csc.liv.ac.uk';
$DATABASE_USER = 'sgtbrett';
$DATABASE_PASS = '';
$DATABASE_NAME = 'sgtbrett';

$id = $_GET['id'];

// Create connection
$con=mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

if ( !isset($id) ) {
        // Couldn't access the id
        exit('Inaccessible data');
}



// searches the questions table for a question with a matching id
$sql = "SELECT Prompt, CorrectAnswer, WrongAnswer1, WrongAnswer2, WrongAnswer3 FROM QuestionsBSLtoENG WHERE QuestionID=$
// Check if there are results
if ($stmt = $con->prepare($sql))
{
        // If so, then create a results array and a temporary one
        // to hold the data
        $stmt->bind_param('i', $id);
        $stmt->execute();

        $stmt->store_result();

        if ($stmt->num_rows > 0) {
                $stmt->bind_result($prompt, $correct, $wrong1, $wrong2, $wrong3);
                $stmt->fetch();

                $row = array($prompt, $correct, $wrong1, $wrong2, $wrong3);
                echo json_encode($row);

        } else {
                // Incorrect id
                echo 'Question ID does not exist';
        }
}
else {
        echo "SQL Statement Failed";
}

// Close connections
mysqli_close($con);
?>
