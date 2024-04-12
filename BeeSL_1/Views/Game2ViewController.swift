//
//  Game2ViewController.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 14/03/2024.
//

import UIKit


class Game2ViewController: UIViewController {
    
    //ui components
    @IBOutlet weak var questionLabel: UILabel!
   // @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    //Array holding the quizs QuestionType2 objects
    var questions: [QuestionType2] = []
    //current quesiton index
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    
    //For completion block
    //called on completion which will pass the score back to the quizoption view controller
    var onCompletion: ((Int, Int) -> Void)?
    
    //placeholder, this is just a string representation
    var lastRecognisedGesture: String?
    //reference to use cameraViewController
    var cameraViewController: CameraViewController!
    
    
    
    var recognizedGestures: [String] = []
    
    var gestureTimer: Timer?

    
    //sets up quesitons when a new quiz gets assigned
    var quiz: Quiz? {
        didSet {
            if isViewLoaded {
                loadQuizQuestions()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        //currentQuestionIndex = 0
        loadQuizQuestions()
    
        // Setup CameraViewController
        //Initializes and sets up the camera view
        cameraViewController = CameraViewController()
        addChild(cameraViewController)
        view.addSubview(cameraViewController.view)
        cameraViewController.didMove(toParent: self)
        // Position the camera view
        positionCameraView()
        
    }
    
    //positions the camera view inbetween the label and the check button
    func positionCameraView() {
        
        cameraViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraViewController.view.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            cameraViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraViewController.view.bottomAnchor.constraint(equalTo: checkButton.topAnchor, constant: -20)
        ])
    }
    
    //prepares first quesiton
    func loadQuizQuestions() {
        
        guard let quizQuestions = quiz?.questions as? [QuestionType2] else { return }
        questions = quizQuestions
        currentQuestionIndex = 0
        moveOntoNextQuestion()
        
    }
    
    //if restart button is pressed in alert then resets all values and goes to first question in quiz
    func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        moveOntoNextQuestion()
        
    }
    //moves onto next question
    func moveOntoNextQuestion() {
        //resets the 'gesture'
        lastRecognisedGesture = nil
        
        if currentQuestionIndex < questions.count {
            
            let currentQuestion = questions[currentQuestionIndex]
            questionLabel.text = currentQuestion.text
            //startGestureRecognition()
            //answerTextField.text = ""
        }
        else {
            //alert when all questions are completed for the given quiz
            completionAlert()
        }
        
    }
    
    //This adjusted method randomly picks one of the current question's answers as the "recognized gesture" after a simulated delay, allowing you to proceed as if a gesture had been recognized.
    
    /*
    //This is a place holder function
    //picks a answer
    //change function so it works with questiontype2 properly (shown in QuizOptionVC)
    func startGestureRecognition() {
        // Simulates a delay before recognizing a gesture, and updates the UI as if a gesture has been recognized
        //not working as intended as user can not get question wrong it just delays, why? idk
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self, self.currentQuestionIndex < self.questions.count else {
                // Consider adding UI-based feedback here for debugging.
                return
            }

            if let correctAnswer = self.questions[self.currentQuestionIndex].answers.first(where: { $0.correct }) {
                self.lastRecognisedGesture = correctAnswer.text
                // Using UI-based feedback for debugging
                /*
                self.questionLabel.text = "Debsug -> Proceed \(correctAnswer.text)"
            } else {
                self.questionLabel.text = "no answer"
                 */
            }
        }
    }
    */
    //This is a place holder function
    //picks a answer
    //change function so it works with questiontype2 properly (shown in QuizOptionVC)
    func startGestureRecognition() {
        // Simulates a delay before recognizing a gesture, and updates the UI as if a gesture has been recognized
        //not working as intended as user can not get question wrong it just delays, why? idk
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self, self.currentQuestionIndex < self.questions.count else {
                // Consider adding UI-based feedback here for debugging.
                return
            }

            if let correctAnswer = self.questions[self.currentQuestionIndex].answers.first(where: { $0.correct }) {
                self.lastRecognisedGesture = correctAnswer.text
                // Using UI-based feedback for debugging
                self.questionLabel.text = "Debug -> Proceed \(correctAnswer.text)"
            } else {
                self.questionLabel.text = "no answer"
            }
        }
    }






    //checks the recognised gesture function when button is tapped
    @IBAction func checkAnswerTapped(_ sender: UIButton) {
        
        // Assuming the lastRecognisedGesture might not be used directly in this context,
        // but you can still keep your guard if it has some use
        guard let recognisedGesture = lastRecognisedGesture else {
            
            //
            //alert here to say: "No gesture recognised, try again" with retry button
            return
        }
        
        checkAnswer(withGesture: recognisedGesture)
    }
    
    // Compares the recognized gestures against the question correct answer
    //compares the recognized gesture against question correct answer.
    func checkAnswer(withGesture gesture: String) {
        DispatchQueue.main.async { [weak self] in
            //current question index is within the bounds of the questions array
            guard let self = self, self.currentQuestionIndex < self.questions.count else {
                self?.completionAlert() //If not show the completion alert
                return
            }
            
            let currentQuestion = self.questions[self.currentQuestionIndex]
            //check if recognised gesture matches correct answer
            if currentQuestion.answers.contains(where: { $0.text.lowercased() == gesture.lowercased() && $0.correct }) {
                self.correctAnswers += 1 //increment correct asnwers
            } else {
                //show wrong answer alert
                self.wrongAnswerAlert()
            }
            //move onto next question or end quiz if all questions answered
            self.currentQuestionIndex += 1
            
            if self.currentQuestionIndex < self.questions.count {
                self.moveOntoNextQuestion()
            } else {
                self.onCompletion?(self.correctAnswers, self.questions.count)
                self.completionAlert()
            }
        }
    }



    
    
   


//explained in gameviewcontroller
    
    func wrongAnswerAlert(){
        let alert = UIAlertController(title: "Incorrect", message: "Get gud and try again cuck", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Next question", style: .default, handler: { [weak self] _ in
            self?.moveOntoNextQuestion()
            
        }))
        present(alert, animated: true)
        return
    }
    
    func completionAlert(){
        let alert = UIAlertController(title: "Done", message: "You got this many correct answers: \(correctAnswers)/\(currentQuestionIndex)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry?", style: .default, handler: { [weak self] _ in
            self?.restartQuiz()
        }))
        alert.addAction(UIAlertAction(title: "Go back", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true)
        return
    }
    
}
