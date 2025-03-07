//
//  QuizOptionViewController.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 11/03/2024.
//

import UIKit



struct NetworkService {
    
}



class QuizOptionViewController: UIViewController {

    
    
    @IBOutlet weak var tableViewQuizzes: UITableView!
    
    @IBOutlet weak var tableViewCreatedQuizzes: UITableView!
    
    


    let selfMadeQuizzes = ["Created quiz 1 (Coming soon...maybe)","Created quiz 2","Created quiz 3", "Created quiz 4"]
    
    //var quizResults: [String: Int] = [:]
    
    
    //Array to hold quiz objects
    var quizzes: [Quiz] = []
    
    //Dictionary to store quiz stores,
    var quizScores: [String: (correctAnswers: Int, totalQuestions: Int)] = [:]
    
    var user: User?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //quizzes = loadQuizzes()
        //Register the custom table view cell nib with the tableViewQuizzes
        tableViewQuizzes.register(QuizTableViewCell.nib(), forCellReuseIdentifier: QuizTableViewCell.identifier)
        
        tableViewQuizzes.delegate = self
        tableViewQuizzes.dataSource = self
        initializeQuizzes()
        
        // Do any additional setup after loading the view.
    }
    
    
    func initializeQuizzes() {
        let networkService = NetworkService()
        let quizTypes: [QuizType] = [.BSLtoEnglish, .EnglishtoBSL, .EnglishtoStaticBSL]
        
        for quizType in quizTypes {
            networkService.fetchQuizzes(type: quizType) { [weak self] fetchedQuizzes in
                for quiz in fetchedQuizzes {
                    networkService.fetchQuestions(forQuizID: quiz.id, type: quiz.type) { questions in
                        var updatedQuiz = quiz
                        updatedQuiz.questions = questions
                        self?.quizzes.append(updatedQuiz)
                        DispatchQueue.main.async {
                            self?.tableViewQuizzes.reloadData()
                        }
                    }
                }
            }
        }
    }
}



extension QuizOptionViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //two sections for BSL quizzes not created quizzes table view
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Learn BSL -> English!"
        case 1:
            return "Learn English -> BSL!"
        case 2:
            return "Learn English -> Static BSL!"
        default:
            return nil
        }
    }

        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewQuizzes {
            let quizType: QuizType
            switch section {
            case 0:
                quizType = .BSLtoEnglish
            case 1:
                quizType = .EnglishtoBSL
            case 2:
                quizType = .EnglishtoStaticBSL
            default:
                return 0
            }
            return quizzes.filter { $0.type == quizType }.count
        } else {
            return selfMadeQuizzes.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewQuizzes {
            
            //configuring cell for quiz item
            let identifier = QuizTableViewCell.identifier
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? QuizTableViewCell else {
                fatalError("Unable to dequeue a QuizTableViewCell")
            }
            
            //changed below from
            //let quizType = indexPath.section == 0 ? QuizType.BSLtoEnglish : QuizType.EnglishtoBSL
            // as this only accepts two arguments
            
            let quizType: QuizType
                    switch indexPath.section {
                    case 0:
                        quizType = .BSLtoEnglish
                    case 1:
                        quizType = .EnglishtoBSL
                    case 2:
                        quizType = .EnglishtoStaticBSL
                    default:
                        fatalError("Unexpected section index")
                    }
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
        // Determine the appropriate view controller based on the quiz type
        let storyboardIdentifier: String
        switch selectedQuiz.type {
        case .BSLtoEnglish:
            storyboardIdentifier = "game"
        case .EnglishtoBSL:
            storyboardIdentifier = "game2"
        case .EnglishtoStaticBSL:
            storyboardIdentifier = "game3"
        }
        
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
            
        } else if let vc = storyboard?.instantiateViewController(withIdentifier: storyboardIdentifier) as? Game3ViewController {
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

extension NetworkService {
    func fetchQuizzes(type: QuizType, completion: @escaping ([Quiz]) -> Void) {
        let urlString: String
        switch type {
        case .BSLtoEnglish:
            urlString = "https://student.csc.liv.ac.uk/~sgtbrett/phpwebservice/getquiz.php?type=bsltoeng"
        case .EnglishtoBSL:
            urlString = "https://student.csc.liv.ac.uk/~sgtbrett/phpwebservice/getquiz.php?type=action"
        case .EnglishtoStaticBSL:
            urlString = "https://student.csc.liv.ac.uk/~sgtbrett/phpwebservice/getquiz.php?type=static"
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching quizzes: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[Any]] {
                    var quizzes: [Quiz] = []
                    for item in jsonArray {
                        if let id = item[0] as? Int,
                           let title = item[1] as? String,
                           let quizTypeString = item[2] as? String,
                           let quizType = QuizType(rawValue: quizTypeString) { // safely unwrap the quiz type
                            let quiz = Quiz(id: id, title: title, type: quizType, questions: [])
                            quizzes.append(quiz)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(quizzes)
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Invalid JSON structure")
                        completion([])
                    }
                }
            } catch {
                print("Failed to parse JSON: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        task.resume()
    }
    
    func fetchQuestions(forQuizID quizID: Int, type: QuizType, completion: @escaping ([QuestionTypes]) -> Void) {
        let urlString: String
        switch type {
        case .BSLtoEnglish:
            urlString = "https://student.csc.liv.ac.uk/~sgtbrett/phpwebservice/getbsltoeng.php?id=\(quizID)"
        case .EnglishtoBSL:
            urlString = "https://student.csc.liv.ac.uk/~sgtbrett/phpwebservice/getengtobsl.php?id=\(quizID)"
        case .EnglishtoStaticBSL:
            urlString = "https://student.csc.liv.ac.uk/~sgtbrett/phpwebservice/getengtobsl.php?id=\(quizID)" // Assuming same URL for static
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching questions: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            var questions: [QuestionTypes] = []
            if let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String]] {
                for questionData in jsonArray {
                    let question = parseQuestion(from: questionData, type: type)
                    questions.append(question)
                }
            }
            DispatchQueue.main.async {
                completion(questions)
            }
        }.resume()
    }

    private func parseQuestion(from data: [String], type: QuizType) -> QuestionTypes {
        // Parse logic based on type and data format
        switch type {
        case .BSLtoEnglish:
            let correctAnswer = Answer(text: data[0], correct: true)
            let answers = data.map { Answer(text: $0, correct: $0 == data[0]) }
            return QuestionType1(text: "What BSL sign is this?", videoFileName: data[0], answers: answers)
        case .EnglishtoBSL, .EnglishtoStaticBSL:
            return QuestionType2(text: "Translate '\(data[0])' into BSL", answers: [Answer(text: data[0], correct: true)])
        }
    }
}

//how old quizzes were handled before the server

/*
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
                    answers: [Answer(text: "yes", correct: true)]
                ),
                QuestionType2(
                    text: "Translate 'Sorry' into BSL",
                    answers: [Answer(text: "sorry", correct: true)]
                ),
                QuestionType2(
                    text: "Translate 'Maybe' into BSL",
                    answers: [Answer(text: "maybe", correct: true)]
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
                    answers: [Answer(text: "red", correct: true)]
                ),
                QuestionType2(
                    text: "Translate 'Brown' into BSL",
                    answers: [Answer(text: "brown", correct: true)]
                ),
                QuestionType2(
                    text: "Translate 'Purple' into BSL",
                    answers: [Answer(text: "purple", correct: true)]
                )
            ]
        ),
        Quiz(
            title: "Basic Letters Quiz",
            type: .EnglishtoStaticBSL,
            questions: [
                QuestionType2(
                    text: "Translate 'F' into BSL",
                    answers: [Answer(text: "F", correct: true)]
                ),
                QuestionType2(
                    text: "Translate 'C' into BSL",
                    answers: [Answer(text: "C", correct: true)]
                ),
                QuestionType2(
                    text: "Translate 'X' into BSL",
                    answers: [Answer(text: "X", correct: true)]
                ),
                QuestionType2(
                    text: "Translate 'O' into BSL",

                    answers: [Answer(text: "O", correct: true)]
                )
                // Add more questions as needed
            ]
        ),
        Quiz(
            title: "Learn the static basics quiz!",
            type: .EnglishtoStaticBSL,
            questions: [
                QuestionType2(
                    text: "Translate 'Yes' into BSL",
                    //how would this be changed to take in letter + letter + letter to form a short word i.e yes
                    answers: [Answer(text: "Y"+"E"+"S", correct: true)]
                ),
                QuestionType2(
                    text: "Translate 'Cat' into BSL",

                    answers: [Answer(text: "C+A+T", correct: true)]
                ),
                QuestionType2(
                    text: "Translate 'No' into BSL",

                    answers: [Answer(text: "N+O", correct: true)]
                )
                // Add more questions as needed
            ]
        ),
        //add more static quizzes as needed

    ]
}
*/
