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
    
    
    /*
    var recognizedGestures: [String] = []
    
    var gestureTimer: Timer?
     */
    
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
        
        setupCameraView()

        //currentQuestionIndex = 0
        loadQuizQuestions()
    
        
        
    }
    //initalizes camera view setup
    func setupCameraView() {
        cameraViewController = CameraViewController()
        addChild(cameraViewController)
        view.addSubview(cameraViewController.view)
        cameraViewController.didMove(toParent: self)
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
        //lastRecognisedGesture = nil
        
        if currentQuestionIndex < questions.count {
            
            let currentQuestion = questions[currentQuestionIndex]
            questionLabel.text = currentQuestion.text
            //startGestureRecognition()
            //answerTextField.text = ""
            simulateGestureRecognition()
        }
        else {
            //alert when all questions are completed for the given quiz
            completionAlert()
        }
        
    }
    
    func simulateGestureRecognition() {
        //dimulate recognition of a gesture after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.lastRecognisedGesture = "Simulated gesture" //dummy gesture for testing
        }
    }
    
    





    //checks the recognised gesture function when button is tapped
    @IBAction func checkAnswerTapped(_ sender: UIButton) {
        
        //understands last gestures (not working), if no gesture debug label lets user know
        guard let recognisedGesture = lastRecognisedGesture, !recognisedGesture.isEmpty else {
            debugLabel.text = "No gesture recognised. Please try again."
            return
        }
        checkAnswer(withGesture: recognisedGesture)
    }
    
    //compares the recognized gestures against the question correct answer

    func checkAnswer(withGesture gesture: String) {
        if currentQuestionIndex < questions.count {
            let currentQuestion = questions[currentQuestionIndex]
            if currentQuestion.answers.contains(where: { $0.text.lowercased() == gesture.lowercased() && $0.correct }) {
                correctAnswers += 1
                debugLabel.text = "Correct!"
                currentQuestionIndex += 1
                moveOntoNextQuestion()
            } else {
                debugLabel.text = "Incorrect! Correct answer was: \(currentQuestion.answers.first { $0.correct }?.text ?? "wrong")"
                wrongAnswerAlert()
            }
        } else {
            onCompletion?(correctAnswers, questions.count)
            completionAlert()
        }
    }



    
    
   


//explained in gameviewcontroller
    
    func wrongAnswerAlert() {
        let alert = UIAlertController(title: "Incorrect", message: "The answer is incorrect, please move onto the next question", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.currentQuestionIndex += 1
            self?.moveOntoNextQuestion()
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func completionAlert() {
        let message = "You got \(correctAnswers) out of \(questions.count) correct."
        let alert = UIAlertController(title: "Quiz finished!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.restartQuiz()
        }))
        alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: { [weak self] _ in
            self?.onCompletion?(self?.correctAnswers ?? 0, self?.questions.count ?? 0)
            self?.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}



