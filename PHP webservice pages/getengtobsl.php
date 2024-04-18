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
$resultArray = array();

$sql = "SELECT QuestionsENGtoBSL.Prompt FROM QuestionsENGtoBSL, ENGtoBSLonQuiz, Quizzes WHERE ENGtoBSLonQuiz.QuestionID=QuestionsENGtoBSL.QuestionID AND Quizzes.QuizID=? AND ENGtoBSLonQuiz.QuizID=?";

// Check if there are results
if ($stmt = $con->prepare($sql))
{
        // If so, then create a results array and a temporary one
        // to hold the data
        $stmt->bind_param('ii', $id, $id);
        $stmt->execute();

        $stmt->store_result();

        $tempArray = array();

        if ($stmt->num_rows > 0) {

                $stmt->data_seek(0);
                $stmt->bind_result($prompt);

                while($stmt->fetch())
                {
                        $tempArray = array($prompt);
                        array_push($resultArray, $tempArray);

                        $stmt->bind_result($prompt);
                }
        }
}
else {
        echo "SQL Statement Failed";
}


echo json_encode($resultArray);

// Close connections
mysqli_close($con);
?>
