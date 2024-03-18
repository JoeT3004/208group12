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
    
    var quizResults: [String: Int] = [:]
    
    var quizzes: [Quiz] = []
    
    
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
                        text: "What BSL sign represents a 'Dog'?",
                        answers: [
                            Answer(text: "Patting your leg", correct: true),
                            Answer(text: "Waving your hand", correct: false),
                            Answer(text: "Pointing to your eye", correct: false),
                            Answer(text: "Making a fish face", correct: false)
                        ]
                    ),
                    QuestionType1(
                        text: "How do you sign 'Cat' in BSL?",
                        answers: [
                            Answer(text: "Pulling whiskers away from face", correct: true),
                            Answer(text: "Flicking your ears", correct: false),
                            Answer(text: "Waving your tail", correct: false),
                            Answer(text: "Climbing a tree motion", correct: false)
                        ]
                    )
                ]
            ),
            Quiz(
                title: "Greetings English Quiz",
                type: .EnglishtoBSL,
                questions: [
                    QuestionType2(
                        text: "Translate 'Hello' into BSL",
                        answers: [Answer(text: "Hello", correct: true)]
                    ),
                    QuestionType2(
                        text: "Translate 'Goodbye' into BSL",
                        answers: [Answer(text: "Goodbye", correct: true)]
                    )
                ]
            )
            // Add more quizzes as needed
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
            
            cell.configure(with: quiz.title)
            cell.delegate = self
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
        // Attempt to find the quiz based on the button's title
        guard let selectedQuiz = quizzes.first(where: { $0.title == title }) else {
            print("Quiz title \(title) did not match known quizzes")
            return
        }
        
        let storyboardIdentifier = selectedQuiz.type == .BSLtoEnglish ? "game" : "game2"
        if let vc = storyboard?.instantiateViewController(withIdentifier: storyboardIdentifier) as? GameViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.quiz = selectedQuiz
            present(vc, animated: true)
        } else if let vc = storyboard?.instantiateViewController(withIdentifier: storyboardIdentifier) as? Game2ViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.quiz = selectedQuiz
            present(vc, animated: true)
        }
    }
}
