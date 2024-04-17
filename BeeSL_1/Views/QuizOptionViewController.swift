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

    let selfMadeQuizzes = ["Created quiz 1 (Coming soon...maybe)","Created quiz 2","Created quiz 3", "Created quiz 4"]
    
    //var quizResults: [String: Int] = [:]
    
    
    //Array to hold quiz objects
    var quizzes: [Quiz] = []
    
    //Dictionary to store quiz stores,
    var quizScores: [String: (correctAnswers: Int, totalQuestions: Int)] = [:]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //quizzes = loadQuizzes()
        //Register the custom table view cell nib with the tableViewQuizzes
        tableViewQuizzes.register(QuizTableViewCell.nib(), forCellReuseIdentifier: QuizTableViewCell.identifier)
        
        tableViewQuizzes.delegate = self
        tableViewQuizzes.dataSource = self
        tableViewCreatedQuizzes.delegate = self
        tableViewCreatedQuizzes.dataSource = self
        
        initializeQuizzes()
        
        // Do any additional setup after loading the view.
    }
    
    //function holds all quiz data
    func initializeQuizzes() {
        quizzes = [
            //first quiz
            Quiz(
                //this would be a displayed in cell row
                title: "Animals BSL Quiz",
                //knows its a question type 1 quiz
                //has to now consistently be question type 1 (GameViewController)
                type: .BSLtoEnglish,
                //questions below
                questions: [
                    //question 1
                    QuestionType1(
                        //label in GameViewController
                        text: "What BSL sign is this?",
                        
                        //Knows to get video file dog
                        videoFileName: "Dog",
                        //answers in table view
                        answers: [
                            Answer(text: "Dog", correct: true),
                            Answer(text: "Cat", correct: false),
                            Answer(text: "Elephant", correct: false),
                            Answer(text: "Frog", correct: false)
                        ]
                        
                        
                    ),
                    QuestionType1(
                        text: "What BSL sign is this?",
                        
                        videoFileName: "Bird",
                        answers: [
                            Answer(text: "Horse", correct: false),
                            Answer(text: "Bird", correct: true),
                            Answer(text: "Giraffe", correct: false),
                            Answer(text: "Bear", correct: false)
                        ]
                        //error: Argument 'videoFileName' must precede argument 'answers'
                        
                    ),
                    //question 2
                    QuestionType1(
                        text: "What BSL sign is this?",
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
            //second quiz
            Quiz(
                title: "Learn the basics!",
                type: .BSLtoEnglish,
                questions: [
                    QuestionType1(
                        text: "What BSL sign is this?",
                        videoFileName: "Whats your name",
                        answers: [
                            Answer(text: "Hello there", correct: false),
                            Answer(text: "Whats your name", correct: true),
                            Answer(text: "What do you mean", correct: false),
                            Answer(text: "My precious", correct: false)
                        ]
                    ),
                    QuestionType1(
                        text: "What BSL sign is this?",
                        videoFileName: "How are you",
                        answers: [
                            Answer(text: "Who are you", correct: false),
                            Answer(text: "Are you okay", correct: false),
                            Answer(text: "What do you mean", correct: false),
                            Answer(text: "How are you", correct: true)
                        ]
                    ),
                    QuestionType1(
                        text: "What BSL sign is this?",
                        videoFileName: "Hello",
                        answers: [
                            Answer(text: "Nope", correct: false),
                            Answer(text: "Yummy", correct: false),
                            Answer(text: "Hello", correct: true),
                            Answer(text: "Morning", correct: false)
                        ]
                    )
                ]
            ),
            Quiz(
                title: "Learn the colours!",
                type: .BSLtoEnglish,
                questions: [
                    QuestionType1(
                        text: "What BSL colour sign is this?",
                        videoFileName: "Blue",
                        answers: [
                            Answer(text: "Brown", correct: false),
                            Answer(text: "Red", correct: false),
                            Answer(text: "Blue", correct: true),
                            Answer(text: "Yellow", correct: false)
                        ]
                    ),
                    QuestionType1(
                        text: "What BSL colour sign is this?",
                        videoFileName: "Yellow",
                        answers: [
                            Answer(text: "Orange", correct: false),
                            Answer(text: "Black", correct: false),
                            Answer(text: "Green", correct: true),
                            Answer(text: "Yellow", correct: true)
                        ]
                    ),
                    QuestionType1(
                        text: "What BSL colour sign is this?",
                        videoFileName: "Pink",
                        answers: [
                            Answer(text: "Pink", correct: true),
                            Answer(text: "Green", correct: false),
                            Answer(text: "Purple", correct: false),
                            Answer(text: "Gold", correct: false)
                        ]
                    )
                ]
            ),
            Quiz(
                title: "Learn the basics 2!",
                //knows its a question type 2 quiz
                //has to now consistently be question type 2 (Game2ViewController)
                type: .EnglishtoBSL,
                questions: [
                    QuestionType2(
                        //prompt of what to sign
                        text: "Translate 'Yes' into BSL",
                        //answer would be sign in real time then the button to check it
                        //functionailty not complete
                        answers: [Answer(text: "Yes", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'Sorry' into BSL",
                        answers: [Answer(text: "Sorry", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'Maybe' into BSL",
                        answers: [Answer(text: "Maybe", correct: true)]
                    )
                ]
            ),
            // Add more quizzes as needed
            Quiz(
                title: "Greetings English Quiz",
                type: .EnglishtoBSL,
                questions: [
                    QuestionType2(
                        text: "Translate 'how-are-you' into BSL",
                        answers: [Answer(text: "how-are-you", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'See you later' into BSL",
                        answers: [Answer(text: "see-you-later", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'purple' into BSL",
                        answers: [Answer(text: "purple", correct: true)]
                    )
                ]
            ),
            Quiz(
                title: "Learn the basics Colours 2!",
                //knows its a question type 2 quiz
                //has to now consistently be question type 2 (Game2ViewController)
                type: .EnglishtoBSL,
                questions: [
                    QuestionType2(
                        //prompt of what to sign
                        text: "Translate 'Red' into BSL",
                        //answer would be sign in real time then the button to check it
                        //functionailty not complete
                        answers: [Answer(text: "Red", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'Brown' into BSL",
                        answers: [Answer(text: "Brown", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'Purple' into BSL",
                        answers: [Answer(text: "Purple", correct: true)]
                    )
                ]
            ),
        ]
    }

}



extension QuizOptionViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //two sections for BSL quizzes not created quizzes table view
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewQuizzes //if tableView.tag == 0{
        {
            //determines the amount of rows based on quiz type given
            let quizType = section == 0 ? QuizType.BSLtoEnglish : QuizType.EnglishtoBSL
            return quizzes.filter { $0.type == quizType }.count
            //return section == 0 ? BSLtoEnglish.count : EnglishToBSL.count
        }
        else{
            //numer of created quizzes
            //not implemented
            return selfMadeQuizzes.count
        }

        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tableViewQuizzes {
            //Header names for each section in quizzes table view
            return section == 0 ? "Learn BSL -> English!" : "Learn English -> BSL!"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewQuizzes {
            
            //configuring cell for quiz item
            let identifier = QuizTableViewCell.identifier
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? QuizTableViewCell else {
                fatalError("Unable to dequeue a QuizTableViewCell")
            }
            
            let quizType = indexPath.section == 0 ? QuizType.BSLtoEnglish : QuizType.EnglishtoBSL
            let filteredQuizzes = quizzes.filter { $0.type == quizType }
            
            let quiz = filteredQuizzes[indexPath.row]
            let quizScore = quizScores[quiz.title]
            //displays score in the table view
            //quizScores[quiz.title] returns an optional tuple (Int, Int)?
            let finalScore = quizScore.map { "\($0.correctAnswers)/\($0.totalQuestions)" } ?? "No score"
            
            cell.configure(with: quiz.title, scoreText: finalScore)
            print("\(finalScore)")
            cell.delegate = self
            
            if quizScores[quiz.title] != nil {
                cell.scoreLabel?.text = finalScore//"\(score.correctAnswers)/\(score.totalQuestions)"
                
            } else {
                cell.scoreLabel?.text = "No score"
            }
            return cell
        } else {
            //configure cell for user created items
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
        
        //Find the quiz that was selected by the title chosen
        guard let selectedQuiz = quizzes.first(where: { $0.title == title }) else {
            print("\(title) did not find a actual quiz")
            return
        }
        
        //depending on the quiz type selected it will instantiate to the correct view controller
        //"game" is ID to GameViewController
        //"game2" is ID to Game2ViewController
        let storyboardIdentifier = selectedQuiz.type == .BSLtoEnglish ? "game" : "game2"
        if let vc = storyboard?.instantiateViewController(withIdentifier: storyboardIdentifier) as? GameViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.quiz = selectedQuiz
            //completion handler used to store and update total questions and correctAnswers
            vc.onCompletion = { [weak self] correctAnswers, totalQuestions in
                self?.quizScores[selectedQuiz.title] = (correctAnswers, totalQuestions)
                //UI update performed to main thread as completion handler may be called in different thread
                DispatchQueue.main.async {
                    self?.tableViewQuizzes.reloadData()
                }
            }
            //Presents the gameview controller
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
