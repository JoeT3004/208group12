//
//  GameViewController.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 12/03/2024.
//

import UIKit
//import AVFoundation
import AVKit



class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Holds the current quizs questions of type QuestionType1 e.g BSL to English
    var questions = [QuestionType1]()
    
    
    var currentQuestion: QuestionTypes?
    var correctAnswers: Int = 0
    //tracks current question index
    var index: Int = 0
    
    //ui components
    @IBOutlet var label: UILabel!
    @IBOutlet var answerTable: UITableView!
    
    //player required for displaying locally stored quesiton videos
    var playerViewController: AVPlayerViewController?
    
    //For completion block
    //called after quiz ends to pass the score to QuizOptionViewController
    var onCompletion: ((Int, Int) -> Void)?

    //Holds the current quiz data which loads questions on set
    var quiz: Quiz? {
        didSet {
            if isViewLoaded {
                loadQuizQuestions()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQuizQuestions()
        // Do any additional setup after loading the view.
    }
    
    //loads first quesiton of the quiz into the UI
    func loadQuizQuestions() {
        guard let quizQuestions = quiz?.questions as? [QuestionType1] else { return }
        questions = quizQuestions
        configureUI(question: questions.first!)
    }
    
    //configures UI so it works with question data given
    private func configureUI(question: QuestionType1){
        label.text = question.text
        currentQuestion = question
        answerTable.delegate = self
        answerTable.dataSource = self
        playVideoForQuestion(question: question)
    }
    
    //standard function that parses in the question so it can be displayed
    func playVideoForQuestion(question: QuestionType1) {
        //error: Value of type 'QuestionType1' has no member 'videofileName'
        guard let path = Bundle.main.path(forResource: question.videoFileName, ofType: "mp4") else {
            print("Where is the video?")
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.view.frame = CGRect(x: 0, y: 180, width: 393, height: 400)
        if let playerView = playerViewController?.view {
            self.view.addSubview(playerView)
        }
        
        
        //plays sign video on repeat
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            player.seek(to: .zero)
            player.play()
        }
        
        player.play()
    }

    
    
    //resets everything including to first quesiton
    func restartQuiz(){
        index = 0
        correctAnswers = 0
        configureUI(question: questions.first!)
        self.answerTable.reloadData()
    }
    
    //moves onto the next question or finishes the quiz
    func moveToNextQuestion() {
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
    }
    
    //checks if chosen answer is correct
    private func checkAnswer(answer: Answer, question: QuestionType1) -> Bool{
        return question.answers.contains(where: { $0.text == answer.text}) && answer.correct
    }
    
    //finds correct answer incase user gets question wrong
    private func findCorrectAnswer (for question: QuestionTypes) -> Answer? {
        return question.answers.first(where: { $0.correct })
    }
    
    
    //answer table view section and functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Safely unwrap currentQuestion using optional binding
        if let currentQuestion = currentQuestion {
            return currentQuestion.answers.count
        } else {
            return 0
        }
    }

    //standard table view methods in order to display answers
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Use optional chaining to access answers property safely
        cell.textLabel?.text = currentQuestion?.answers[indexPath.row].text
        return cell
    }

    //this basically checks what answer was selected and handles that
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        // Safely unwrap currentQuestion using optional binding
        if let question = currentQuestion {
            
            //gets selectedAnswer based on which row the user tapped
            let selectedAnswer = question.answers[indexPath.row]
           
            //compares selected answer to correct answer
            if checkAnswer(answer: selectedAnswer, question: question as! QuestionType1) {
                print("correct")
                //if correct increments index and moves to next question
                //counter for correctAnswers so it can be displayed
                correctAnswers += 1
                if let index = questions.firstIndex(where: { $0.text == question.text }) {
                    moveToNextQuestion()
                }
            } else {
                print("wrong")
                //alert to tell user they got a question wrong.
                if let correctAnswer = findCorrectAnswer(for: question) {
                    //Presents an alert with the correct answer
                    let alert = UIAlertController(title: "Wrong", message: "Get Gud, the correct answer is: \(correctAnswer.text)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Next question", style: .default, handler: { [weak self] _ in
                        self?.moveToNextQuestion()
                    }))
                    present(alert, animated: true)
                }
            }
        }
    }
    
    
    
    //alert to tell user the quiz is finished
    func completionAlert(){
        //displays how many user got correct when quiz is finished
        let alert = UIAlertController(title: "Done", message: "You got this many correct answers: \(correctAnswers)/\(index)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry?", style: .default, handler: { [weak self] _ in
            //restart quiz from currentQuestionIndex (index) of 0
            self?.restartQuiz()
        }))
        alert.addAction(UIAlertAction(title: "Go back", style: .default, handler: { [weak self] _ in
            //dimisses this view and goes back to QuizOptionViewController
            self?.dismiss(animated: true, completion: nil)
            
        }))
        
        present(alert, animated: true)
        return
    }
}
