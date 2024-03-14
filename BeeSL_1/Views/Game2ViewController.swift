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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestions()
        displayCurrentQuestion()
        // Do any additional setup after loading the view.
    }
    
    private func setupQuestions() {
        questions.append(QuestionType2(text: "Translate Hello into BSL", answers: [Answer(text: "Hello", correct: true)]))
        questions.append(QuestionType2(text: "Translate Hello into BSL", answers: [Answer(text: "Hello", correct: true)]))
        questions.append(QuestionType2(text: "Translate Hello into BSL", answers: [Answer(text: "Hello", correct: true)]))
        questions.append(QuestionType2(text: "Translate Hello into BSL", answers: [Answer(text: "Hello", correct: true)]))
        questions.append(QuestionType2(text: "Translate Hello into BSL", answers: [Answer(text: "Hello", correct: true)]))
    }
    
    private func displayCurrentQuestion() {
        guard currentQuestionIndex < questions.count else {
            
            let alert = UIAlertController(title: "Quiz is complete", message: "Well done", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "wooo ok", style: .default) { _ in self.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
            return
        }
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.text
        answerTextField.text = ""
    }
    
    @IBAction func checkAnswerTapped(_ sender: UIButton) {
        
        
        
        guard currentQuestionIndex < questions.count else { return }
        let currentQuestion = questions[currentQuestionIndex]
        let userAnswer = answerTextField.text ?? ""
        
        if currentQuestion.answers.contains(where: { $0.text.lowercased() == userAnswer.lowercased() && $0.correct}) {
            //correct will now move onto next question
            currentQuestionIndex += 1
            displayCurrentQuestion()
        } else {
            let alert = UIAlertController(title: "Incorrect", message: "Get gud and try again cuck", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }

    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
