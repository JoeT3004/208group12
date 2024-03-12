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
    
    let ourQuizzes = ["quiz 1","quiz 2","quiz 3", "quiz 4"]
    let selfMadeQuizzes = ["Created quiz 1","Created quiz 2","Created quiz 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewQuizzes.register(QuizTableViewCell.nib(), forCellReuseIdentifier: QuizTableViewCell.identifier)
        
        tableViewQuizzes.delegate = self
        tableViewQuizzes.dataSource = self
        tableViewCreatedQuizzes.delegate = self
        tableViewCreatedQuizzes.dataSource = self
        
        // Do any additional setup after loading the view.
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0
        {
            return ourQuizzes.count
        }
        else{
            return selfMadeQuizzes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0
        {
            let cell = tableViewQuizzes.dequeueReusableCell(withIdentifier: QuizTableViewCell.identifier, for: indexPath) as! QuizTableViewCell
            cell.configure(with: ourQuizzes[indexPath.row])
            cell.delegate = self
            return cell
        }
        else{
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
        
        //can do || or if statements to decide which quizzes do what when tapped
        if title == "quiz 1" || title == "quiz 2" {
            print("\(title)")
            let vc = storyboard?.instantiateViewController(withIdentifier: "game") as! GameViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            //some functionality here to say: if quiz 1 was picked when reaching the new view controller then quiz one will play. this will be done in the new view controller.
        }

    }
}
