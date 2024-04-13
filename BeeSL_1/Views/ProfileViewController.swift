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
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    
    func updateUI() {
        
        if let user = (self.tabBarController as? TabBarViewController)?.user {
            
            usernameLabel.text = "Username: \(user.username)"
            fullNameLabel.text = "Full name: \(user.firstName) \(user.lastName)"
        }
    }
    @IBAction func logoutPressed(_ sender: UIButton) {
        logoutUser()
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        confirmAccountDeletion()
    }
    
    func logoutUser() {
        DispatchQueue.main.async {
            guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
                return
            }

            // Adjust this code to find the appropriate scene
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController = loginViewController
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }
    }

    
    func confirmAccountDeletion() {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? ", preferredStyle: .alert)
        
        //text field for the password
        alert.addTextField { textField in
            textField.placeholder = "Enter your password"
            textField.isSecureTextEntry = true //make sure the password entry is secure
        }
        
        // Add actions
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let password = alert.textFields?.first?.text, !password.isEmpty else {
                print("Password field is empty.")
                return // Optionally show an error message or shake the alert
            }
            self?.deleteUserAccount(password: password)
        }
        alert.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
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
                    print("Network request error: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    if responseString.contains("successfully deleted") {
                        self?.logoutUser() // Navigate back to login screen
                    } else {
                        print("Deletion failed: \(responseString)") // Log or handle the error
                    }
                }
            }
        }
        task.resume()
    }

}
