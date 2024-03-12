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

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var gameModels1 = [QuestionType1]()
    //not implemented yet
    var gameModels2 = [QuestionType2]()
    
    var currentQuestion: QuestionTypes
    
    @IBOutlet var label: UILabel!
    @IBOutlet var answerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestions()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        configureUI(question: gameModels1.first!)
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
        gameModels1.append(QuestionType1(text: "what is two plus two", answers: [
            Answer(text: "4", correct: true),
            Answer(text: "3", correct: false),
            Answer(text: "5", correct: false),
            Answer(text: "2", correct: false)
        
        ]))
        
        gameModels1.append(QuestionType1(text: "what is 5 minus 1", answers: [
            Answer(text: "5", correct: true),
            Answer(text: "3", correct: false),
            Answer(text: "4", correct: false),
            Answer(text: "2", correct: false)
        
        ]))
        
        gameModels1.append(QuestionType1(text: "what is 3 plus 3", answers: [
            Answer(text: "4", correct: true),
            Answer(text: "3", correct: false),
            Answer(text: "5", correct: false),
            Answer(text: "6", correct: false)
        
        ]))
        
        gameModels1.append(QuestionType1(text: "What is the true final boss in bloodborne?", answers: [
            Answer(text: "Gehrman, The First Hunter", correct: true),
            Answer(text: "Moon Presence", correct: false),
            Answer(text: "Mergos Wet Nurce", correct: false),
            Answer(text: "Orphan of Kos", correct: false)
        
        ]))
    }
    
    //here there should be two types of questions (just one for now)
    
    //before reading below:
    //game may be easier to code if we have two types of questinos that the user can pick from, this will be done with one table on the quiz optino view controller with two sections one for english -> bsl and the other section of quizzes for bsl -> english
    
    // the question for my app should have:
    
    //Question type 1: BSL -> English
    //variable for the video player which is the quesiton variable
    //count for question number
    // Answers variable
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
    
    //may have to have multiple answer types (not sure)
    //if incorrect give the correct answer
    //if question type 1 a correct video gesture displayed
    // if question type 2 correct translated sword will show or will display in green and answer picked will be highlighted in red after user has chosen an answer.
    struct Answer {
        let text: String
        let correct: Bool
        
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
