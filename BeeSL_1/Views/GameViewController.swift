//
//  GameViewController.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 12/03/2024.
//

import UIKit

protocol QuestionTypes{
    var text: String { get }
    var answers: [Answer] { get }
    //hand gesture variable
}

struct QuestionType1: QuestionTypes {
    var text: String
    var answers: [Answer]
}


struct Answer {
    let text: String
    let correct: Bool
}

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var questions = [QuestionType1]()
    //not implemented yet
    
    var currentQuestion: QuestionTypes?
    var correctAnswers: Int = 0
    var index: Int = 0
    
    @IBOutlet var label: UILabel!
    @IBOutlet var answerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestions()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        configureUI(question: questions.first!)
    }
    
    private func configureUI(question: QuestionType1){
        label.text = question.text
        currentQuestion = question
        answerTable.delegate = self
        answerTable.dataSource = self
    }
    
    private func checkAnswer(answer: Answer, question: QuestionType1) -> Bool{
        return question.answers.contains(where: { $0.text == answer.text}) && answer.correct
    }
    
    //right now this is just simple text questions
    // will be changed to display a video player
    private func setupQuestions() {
        questions.append(QuestionType1(text: "what is two plus two", answers: [
            Answer(text: "4", correct: true),
            Answer(text: "3", correct: false),
            Answer(text: "5", correct: false),
            Answer(text: "2", correct: false)
            
        ]))
        
        questions.append(QuestionType1(text: "what is 5 minus 1", answers: [
            Answer(text: "5", correct: true),
            Answer(text: "3", correct: false),
            Answer(text: "4", correct: false),
            Answer(text: "2", correct: false)
            
        ]))
        
        questions.append(QuestionType1(text: "what is 3 plus 3", answers: [
            Answer(text: "4", correct: false),
            Answer(text: "3", correct: false),
            Answer(text: "5", correct: false),
            Answer(text: "6", correct: true)
            
        ]))
        
        questions.append(QuestionType1(text: "What is the true final boss in bloodborne?", answers: [
            Answer(text: "Gehrman, The First Hunter", correct: true),
            Answer(text: "Moon Presence", correct: false),
            Answer(text: "Mergos Wet Nurce", correct: false),
            Answer(text: "Orphan of Kos", correct: false)
            
        ]))
    }
    
    func restartQuiz(){
        index = 0
        correctAnswers = 0
        configureUI(question: questions.first!)
        self.answerTable.reloadData()
    }
    
    func moveToNextQuestion() {
        index += 1
        if index < questions.count {
            let nextQuestion = questions[index]
            configureUI(question: nextQuestion)
            answerTable.reloadData()
        }
        else {
            completionAlert()
        }
        
    }
    
    
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Use optional chaining to access answers property safely
        cell.textLabel?.text = currentQuestion?.answers[indexPath.row].text
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        // Safely unwrap currentQuestion using optional binding
        if let question = currentQuestion {
            
            let selectedAnswer = question.answers[indexPath.row]
            //let answer = question.answers[indexPath.row]
           
            if checkAnswer(answer: selectedAnswer, question: question as! QuestionType1) {
                print("correct")
                correctAnswers += 1
                if let index = questions.firstIndex(where: { $0.text == question.text }) {
                    moveToNextQuestion()
                }
            } else {
                print("wrong")
                
                if let correctAnswer = findCorrectAnswer(for: question) {
                    let alert = UIAlertController(title: "Wrong", message: "Get Gud, the correct answer is: \(correctAnswer.text)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Next question", style: .default, handler: { [weak self] _ in
                        self?.moveToNextQuestion()
                    }))
                    present(alert, animated: true)
                }

            }
        }
    }
    
    
    func completionAlert(){
        let alert = UIAlertController(title: "Done", message: "You got this many correct answers: \(correctAnswers)/\(index)", preferredStyle: .alert)
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

    //here there should be two types of questions (just one for now)
    
    //before reading below:
    //game may be easier to code if we have two types of questinos that the user can pick from, this will be done with one table on the quiz optino view controller with two sections one for english -> bsl and the other section of quizzes for bsl -> english
    
    // the question for my app should have:
    
    //Question type 1: BSL -> English
    //variable for the video player which is the quesiton variable
    //count for question number
    // Answers variable
    /*
    struct QuestionType1 {
        var text: String //this will be replaced by a video of sign
        var answers: [Answer]
    }
    

    //Question type 2: English -> BSL
    //To use both question types this is where a randomiser would be used to switch between them both.
    struct QuestionType2 {
        //This will be implemented after question type 1 implementation
        var text: String
        var answers: [Answer]
        //hand gesture variable
    }
    */
    //may have to have multiple answer types (not sure)
    //if incorrect give the correct answer
    //if question type 1 a correct video gesture displayed
    // if question type 2 correct translated sword will show or will display in green and answer picked will be highlighted in red after user has chosen an answer.
    /*
    struct Answer {
        let text: String
        let correct: Bool
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     

     }*/
