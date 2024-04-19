//
//  LoginViewController.swift
//  BeeSL_1
//
//  Created by Taylor, Joe [sgjtay21] on 11/03/2024.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var textFieldUser: UITextField!
    
    @IBOutlet weak var textFieldPass: UITextField!
    @IBOutlet weak var loginResult: UILabel!
    
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        //can also be if (textFieldUser.text = "" || textFieldPass.text == "") {
        //if (((textFieldUser.text?.isEmpty) != nil) || ((textFieldPass.text?.isEmpty) != nil)){
        if let username = textFieldUser.text, let password = textFieldPass.text, !username.isEmpty, !password.isEmpty {
            loginUser(username: username, password: password)
        } else {
            loginResult.text = "Username and password required"
            loginResult.isHidden = false
        }
        

    }
    
    @IBAction func guestButton(_ sender: UIButton) {
        let guestUser = User(username: "Guest", firstName: "", lastName: "", password: "")
        navigateToMainTabBarController(with: guestUser)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginResult.isHidden = true

        
        textFieldUser.delegate = self
        textFieldPass.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    
    func constructLoginURL(username: String, password: String) -> URL? {
        let baseURL = "https://student.csc.liv.ac.uk/~sgtbrett/phpwebservice/verifyuser.php"
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        return components.url
    }
    
    func loginUser(username: String, password: String) {
        guard let url = constructLoginURL(username: username, password: password) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loginResult.isHidden = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.loginResult.text = "Network request error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.loginResult.text = "failed"
                }
                return
            }
            
            do {
                // Attempt to decode the JSON response
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    // Assuming the response array format is ["username", "firstname", "lastname"]
                    if jsonResponse.count >= 3 {
                        let username = jsonResponse[0]
                        let firstName = jsonResponse[1]
                        let lastName = jsonResponse[2]
                        
                        // Proceed with this user data as needed
                        // Replace this part in your loginUser method
                        DispatchQueue.main.async {
                            let user = User(username: username, firstName: firstName, lastName: lastName, password: password)
                            self.navigateToMainTabBarController(with: user)
                        }

                    } else {
                        DispatchQueue.main.async {
                            self.loginResult.text = "User data incorrect, please try again"
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.loginResult.text = "Login failed, please try again"
                }
            }
        }
        task.resume()
    }

    
    func navigateToMainTabBarController(with user: User) {
        DispatchQueue.main.async {
            if let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? TabBarViewController {
                mainTabBarController.user = user // Make sure this user is being set
                if let windowScene = self.view.window?.windowScene, let window = windowScene.windows.first {
                    window.rootViewController = mainTabBarController
                    window.makeKeyAndVisible()
                }
            }
        }
    }
}
