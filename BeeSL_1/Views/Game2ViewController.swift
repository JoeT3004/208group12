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
   //@IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    //Array holding the quizs QuestionType2 objects
    var questions: [QuestionType2] = []
    //current quesiton index
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    
    var handle_BSL: BSL_Handler?
    var type_of_quiz: String?
    
    //For completion block
    //called on completion which will pass the score back to the quizoption view controller
    var onCompletion: ((Int, Int) -> Void)?
    
    //placeholder, this is just a string representation
    var lastRecognisedGesture: String?
    //reference to use cameraViewController
    
    var currentquestion: String?
    
    /*
    var recognizedGestures: [String] = []
    
    var gestureTimer: Timer?
     */
    
    //sets up quesitons when a new quiz gets assigned
    
    var quiz: Quiz?/*
    {
        didSet {
            if isViewLoaded {
                
            }
        }
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupCameraView()

        //currentQuestionIndex = 0
        loadQuizQuestions()
    
        
    }
    //initalizes camera view setup

    
    //prepares first quesiton
    func loadQuizQuestions() {
        
        guard let quizQuestions = quiz?.questions as? [QuestionType2] else { return }
        questions = quizQuestions
        currentQuestionIndex = 0
        
        type_of_quiz = "Action"
        
         handle_BSL = BSL_Handler(session_Type_param:type_of_quiz!)
        
        if let working_handle_BSL = handle_BSL{
            if(working_handle_BSL.working == false)
            {
                printbadServerAlert()
            }
        }
        else {
            printbadServerAlert()
        }
        
        adviseAlert()
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
        /*
         index += 1
         if index < questions.count {
             let nextQuestion = questions[index]
             configureUI(question: nextQuestion)
             playerViewController?.view.removeFromSuperview()
             playVideoForQuestion(question: nextQuestion)
             answerTable.reloadData()
         }
         else {
             onCompletion?(correctAnswers, questions.count)
             completionAlert()
         }
         */
        print("got to this point")
        
        print(questions.count)
        print(currentQuestionIndex)
        if currentQuestionIndex < questions.count {
            
            let currentQuestion = questions[currentQuestionIndex]
            
            questionLabel.text = currentQuestion.text
            
            currentquestion = questions[currentQuestionIndex].answers[0].text
            
            //startGestureRecognition()
            //answerTextField.text = ""
            
            
            currentQuestionIndex = currentQuestionIndex + 1
        }
        else {
            //alert when all questions are completed for the given quiz
            onCompletion?(correctAnswers, questions.count)
            completionAlert()
        }
        
        
    }
    
 
    func startGestureRecognition() -> String{
       
        
        
        if let working_handle_BSL = handle_BSL{
            var handled_question = working_handle_BSL.check_Gesture(gesture: currentquestion!)
            print(handled_question)
            return handled_question
        }
        else {
            printbadServerAlert()
            return "Error"
        }
       
        
    }
    
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        checkAnswer()
    }
    
    
    
    func checkAnswer() {
        
            var answer = startGestureRecognition()
            if (answer == "Correct")
            {
                if(currentQuestionIndex < questions.count)
                {
                    correctAnswers += 1
                    debugLabel.text = "Correct!"
                    CorrectAnswerAlert()
                    moveOntoNextQuestion()
                }
                else
                {
                    correctAnswers += 1
                    debugLabel.text = "Correct!"
                    moveOntoNextQuestion()
                }
                
            }
            else if (answer == "False")
            {
                if(currentQuestionIndex < questions.count)
                {
                    wrongAnswerAlert()
                    moveOntoNextQuestion()
                }
                else
                {
                    moveOntoNextQuestion()
                }
                
            }
            else
            {
                printbadServerAlert()
                print("error")
            }
            

    }



    
    
   
func printbadServerAlert()
    {
        let alert = UIAlertController(title: "BAD server", message: "please ensure the server is on before starting static or action questions", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                guard let quizOptionViewController = self?.storyboard?.instantiateViewController(withIdentifier: "quiz") else {
                    return
                }

                //finds the appropriate scene
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.first?.rootViewController = quizOptionViewController
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            }
        }))
        
            present(alert, animated: true)
        
    }

//explained in gameviewcontroller
    
    func wrongAnswerAlert() {
        let alert = UIAlertController(title: "Incorrect", message: "Ran out of time, please move onto the next question", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
           
        }))
        
            self.present(alert, animated: true)
        
    }
    
    func CorrectAnswerAlert() {
        let alert = UIAlertController(title: "Correct", message: "You signed it correctly!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
           
        }))
            self.present(alert, animated: true)
        
    }
    func adviseAlert() {
        let alert = UIAlertController(title: "Wait read this", message: "Sometimes changing speed, switching hands or changing distance from camera helps your signs be identified easier", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            
        }))
        
            self.present(alert, animated: true)
        
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
            self?.handle_BSL?.end()
        }))
        
            self.present(alert, animated: true)
        
    }
}





