//
//  Game2ViewController.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 14/03/2024.
//

import UIKit


struct QuestionType2: QuestionTypes {
    var text: String
    var answers: [Answer]
}

class Game2ViewController: UIViewController {
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    
    var questions: [QuestionType2] = []
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestions()
        //currentQuestionIndex = 0
        moveOntoNextQuestion()
        // Do any additional setup after loading the view.
    }
    
    private func setupQuestions() {
        questions.append(QuestionType2(text: "Translate Hello into BSL", answers: [Answer(text: "Hello", correct: true)]))
        questions.append(QuestionType2(text: "Translate Hello into BSL", answers: [Answer(text: "Hello", correct: true)]))
        questions.append(QuestionType2(text: "Translate Hello into BSL", answers: [Answer(text: "Hello", correct: true)]))
        questions.append(QuestionType2(text: "Translate Hello into BSL", answers: [Answer(text: "Hello", correct: true)]))
    }
    
    func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        moveOntoNextQuestion()
        
    }
    
    func moveOntoNextQuestion() {
        
        if currentQuestionIndex < questions.count {
            
            let currentQuestion = questions[currentQuestionIndex]
            questionLabel.text = currentQuestion.text
            answerTextField.text = ""
        }
        else {
            completionAlert()
        }
        
    }
    
  
    @IBAction func checkAnswerTapped(_ sender: UIButton) {
        
        guard currentQuestionIndex < questions.count else {
            completionAlert()
            return
        }
        
        
        let currentQuestion = questions[currentQuestionIndex]
        let userAnswer = answerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        
        if currentQuestion.answers.contains(where: { $0.text.lowercased() == userAnswer && $0.correct}){
            correctAnswers += 1
        }
        else{
            wrongAnswerAlert()
        }
        
        
        if currentQuestionIndex < questions.count {
            moveOntoNextQuestion()
        }
        
        currentQuestionIndex += 1
        
        if currentQuestionIndex < questions.count {
            moveOntoNextQuestion()
        }
        else{
            completionAlert()
        }
    }
    
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
