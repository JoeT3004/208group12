//
//  QuizOptionViewController.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 11/03/2024.
//

import UIKit



class QuizOptionViewController: UIViewController {

    @IBOutlet weak var tableViewQuizzes: UITableView!
    
    @IBOutlet weak var tableViewCreatedQuizzes: UITableView!
    
    
    //Originally the two arrays were here which should't be used in the first place
    //let BSLtoEnglish = ["quiz 1","quiz 2","quiz 3", "quiz 4"]
    
    //let englishToBSL = ["Quiz a", "Quiz b", "Quiz z"]

    let selfMadeQuizzes = ["Created quiz 1","Created quiz 2","Created quiz 3"]
    
    //var quizResults: [String: Int] = [:]
    
    var quizzes: [Quiz] = []
    
    var quizScores: [String: (correctAnswers: Int, totalQuestions: Int)] = [:]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //quizzes = loadQuizzes()
        
        tableViewQuizzes.register(QuizTableViewCell.nib(), forCellReuseIdentifier: QuizTableViewCell.identifier)
        
        tableViewQuizzes.delegate = self
        tableViewQuizzes.dataSource = self
        tableViewCreatedQuizzes.delegate = self
        tableViewCreatedQuizzes.dataSource = self
        
        initializeQuizzes()
        
        // Do any additional setup after loading the view.
    }
    
    func initializeQuizzes() {
        quizzes = [
            Quiz(
                title: "Animals BSL Quiz",
                type: .BSLtoEnglish,
                questions: [
                    QuestionType1(
                        //Change to "What BSL sign is this"
                        text: "What BSL sign is this? (Dog)",
                        
                        videoFileName: "Dog",
                        //Here would be vid of sign
                        answers: [
                            Answer(text: "Dog", correct: true),
                            Answer(text: "Cat", correct: false),
                            Answer(text: "Elephant", correct: false),
                            Answer(text: "Frog", correct: false)
                        ]
                        //error: Argument 'videoFileName' must precede argument 'answers'
                        
                    ),
                    QuestionType1(
                        text: "What BSL sign is this? (Cow)",
                        videoFileName: "Cow",
                        answers: [
                            Answer(text: "Pig", correct: false),
                            Answer(text: "Monke", correct: false),
                            Answer(text: "Cow", correct: true),
                            Answer(text: "Orangatang", correct: false)
                        ]
                    )
                ]
            ),
            
            Quiz(
                title: "Learn the basics!",
                type: .BSLtoEnglish,
                questions: [
                    QuestionType1(
                        text: "What BSL sign is this? ('Whats your name')",
                        videoFileName: "Whats your name",
                        answers: [
                            Answer(text: "Hello there", correct: false),
                            Answer(text: "Whats your name", correct: true),
                            Answer(text: "Hell no to the no no no", correct: false),
                            Answer(text: "My precious", correct: false)
                        ]
                    ),
                    QuestionType1(
                        text: "What BSL sign is this? ('How are you?')",
                        videoFileName: "How are you",
                        answers: [
                            Answer(text: "What do you want biotch", correct: false),
                            Answer(text: "Mammaaaa ooooooo", correct: false),
                            Answer(text: "What do you mean", correct: false),
                            Answer(text: "How are you", correct: true)
                        ]
                    )
                ]
            ),
            Quiz(
                title: "Learn the basics 2!",
                type: .EnglishtoBSL,
                questions: [
                    QuestionType2(
                        //prompt of what to sign
                        text: "Translate 'Yes' into BSL",
                        //answer would be sign in real time then the button to check it
                        answers: [Answer(text: "Yes", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'Sorry' into BSL",
                        answers: [Answer(text: "Sorry", correct: true)]
                    )
                ]
            ),
            // Add more quizzes as needed
            Quiz(
                title: "Greetings English Quiz",
                type: .EnglishtoBSL,
                questions: [
                    QuestionType2(
                        text: "Translate 'Hello' into BSL",
                        answers: [Answer(text: "Hello", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'See you later' into BSL",
                        answers: [Answer(text: "See you later", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'Good afternoon' into BSL",
                        answers: [Answer(text: "Good afternoon", correct: true)]
                    )
                ]
            ),
        ]
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



extension QuizOptionViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewQuizzes //if tableView.tag == 0{
        {
            
            let quizType = section == 0 ? QuizType.BSLtoEnglish : QuizType.EnglishtoBSL
            return quizzes.filter { $0.type == quizType }.count
            //return section == 0 ? BSLtoEnglish.count : EnglishToBSL.count
        }
        else{
            return selfMadeQuizzes.count
        }

        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tableViewQuizzes {
            return section == 0 ? "Learn BSL -> English!" : "Learn English -> BSL!"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewQuizzes {
            
            
            let identifier = QuizTableViewCell.identifier
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? QuizTableViewCell else {
                fatalError("Unable to dequeue a QuizTableViewCell")
            }
            
            let quizType = indexPath.section == 0 ? QuizType.BSLtoEnglish : QuizType.EnglishtoBSL
            let filteredQuizzes = quizzes.filter { $0.type == quizType }
            
            let quiz = filteredQuizzes[indexPath.row]
            let quizScore = quizScores[quiz.title]
            let finalScore = quizScore.map { "\($0.correctAnswers)/\($0.totalQuestions)" } ?? "No score"
            
            cell.configure(with: quiz.title, scoreText: finalScore)
            print("\(finalScore)")
            cell.delegate = self
            
            if let score = quizScores[quiz.title] {
                cell.scoreLabel?.text = "\(score.correctAnswers)/\(score.totalQuestions)"
                
            } else {
                cell.scoreLabel?.text = "No score"
            }
            return cell
        } else {
            
            let cell = tableViewCreatedQuizzes.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selfMadeQuizzes[indexPath.row]
            return cell
        }
        
    }
    
}

//QuizTableViewDelegate = MyTableVeiwCellDelegate
extension QuizOptionViewController: QuizTableViewDelegate {
    
    
    // some functionality here?? -> if quiz1 then play quiz 1, elsif quiz 2
    func didTapButton(with title: String) {
        guard let selectedQuiz = quizzes.first(where: { $0.title == title }) else {
            print("Quiz title \(title) did not match known quizzes")
            return
        }
        
        let storyboardIdentifier = selectedQuiz.type == .BSLtoEnglish ? "game" : "game2"
        if let vc = storyboard?.instantiateViewController(withIdentifier: storyboardIdentifier) as? GameViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.quiz = selectedQuiz
            vc.onCompletion = { [weak self] correctAnswers, totalQuestions in
                self?.quizScores[selectedQuiz.title] = (correctAnswers, totalQuestions)
                DispatchQueue.main.async {
                    self?.tableViewQuizzes.reloadData()
                }
            }
            present(vc, animated: true)
        } else if let vc = storyboard?.instantiateViewController(withIdentifier: storyboardIdentifier) as? Game2ViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.quiz = selectedQuiz
            vc.onCompletion = { [weak self] correctAnswers, totalQuestions in
                self?.quizScores[selectedQuiz.title] = (correctAnswers, totalQuestions)
                DispatchQueue.main.async {
                    self?.tableViewQuizzes.reloadData()
                }
            }
            present(vc, animated: true)
        }
    }

}
