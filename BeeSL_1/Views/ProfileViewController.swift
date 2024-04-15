//
//  ProfileViewController.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 11/04/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfileUI() //Make sure this is called every time the view appears
    }

    
    
    func updateProfileUI() {
        if let user = (self.tabBarController as? TabBarViewController)?.user {
            if user.username == "Guest" {
                // Handling UI updates specifically for guest users
                usernameLabel.text = "Username: Guest"
                fullNameLabel.text = "Full name: No name available"
            } else {
                // Handling UI updates for regular users
                usernameLabel.text = "Username: \(user.username)"
                fullNameLabel.text = "Full name: \(user.firstName) \(user.lastName)"
            }
        } else {
            // Fallback if user is somehow nil - might be useful to handle unexpected cases
            usernameLabel.text = "Error: User data unavailable"
            fullNameLabel.text = "Error: No additional data"
        }
    }



    
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        logoutUser()
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        
            //If not a guest, proceed with the regular deletion confirmation
        confirmAccountDeletion()
        
    }
    
    //sends user back to the logoin menu allowing user to sign in with a different account
    func logoutUser() {
        DispatchQueue.main.async {
            guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
                return
            }

            //finds the appropriate scene
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController = loginViewController
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }
    }

    
    func confirmAccountDeletion() {
        
        print("Current username: \(user?.username ?? "nil")") //Debug statement to check the username value
        
        if let user = (self.tabBarController as? TabBarViewController)?.user {
            //Check if the current user is a guest
            if user.username == "Guest" {
                //Present an alert that indicates deletion is not possible for guest accounts
                let alert = UIAlertController(title: "Not avaliable", message: "Can't delete account as using a guest account", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Go back", style: .cancel, handler: nil) //Only a cancel option
                alert.addAction(cancelAction)
                present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Deleting account..", message: "Are you sure you want to delete your account? ", preferredStyle: .alert)
                
                //text field for the password
                alert.addTextField { textField in
                    textField.placeholder = "Please enter your password"
                    textField.isSecureTextEntry = true //make sure the password entry is secure
                }
                
                // Add actions
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                    guard let password = alert.textFields?.first?.text, !password.isEmpty else {
                        print("Password field is empty")
                        return // Optionally show an error message or shake the alert
                    }
                    self?.deleteUserAccount(password: password)
                }
                alert.addAction(deleteAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                present(alert, animated: true)
                
            }
        } else {
            //if user is somehow nil
            //just acts if user is guest
            let alert = UIAlertController(title: "Unavailable", message: "Can't delete account as using a guest account", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil) // Only a cancel option
            alert.addAction(cancelAction)
            present(alert, animated: true)
            
        }
        
        
    }



    
    func deleteUserAccount(password: String) {
        // Ensure the password is correctly appended to the URL
        guard let url = URL(string: "https://student.csc.liv.ac.uk/~sgtbrett/phpwebservice/deleteuser.php?password=\(password)") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url) // Using GET method, consider changing to POST for security

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    print("\(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    if responseString.contains("successfully deleted") {
                        self?.logoutUser() //Navigate back to login screen
                    } else {
                        print("Deletion failed: \(responseString)") // Log or handle the error
                    }
                }
            }
        }
        task.resume()
    }

}
