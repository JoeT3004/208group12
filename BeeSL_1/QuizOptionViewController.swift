//
//  QuizOptionViewController.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 11/03/2024.
//

import UIKit

class QuizOptionViewController: UIViewController {

    @IBOutlet weak var quizzes: UITableView!
    
    @IBOutlet weak var createdQuizzes: UITableView!
    
    let ourQuizzes = ["quiz 1","quiz 2","quiz 3"]
    let selfMadeQuizzes = ["Created quiz 1","Created quiz 2","Created quiz 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizzes.delegate = self
        quizzes.dataSource = self
        createdQuizzes.delegate = self
        createdQuizzes.dataSource = self
        
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
            let cell = quizzes.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = ourQuizzes[indexPath.row]
            return cell
        }
        else{
            let cell = createdQuizzes.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = selfMadeQuizzes[indexPath.row]
            return cell
            
        }
    }
    
}
