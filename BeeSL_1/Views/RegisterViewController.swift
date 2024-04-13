//
//  RegisterViewController.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 09/04/2024.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var regUserTextField: UITextField!
    
    @IBOutlet weak var regFirstNameTextField: UITextField!
    
    @IBOutlet weak var regLastNameTextField: UITextField!
    @IBOutlet weak var regPassTextField: UITextField!
    
    @IBOutlet weak var regButton: UIButton!
    
    //label only shows if all the text fields have not been answered correctly
    //This will not show if user registers correctly
    @IBOutlet weak var regResult: UILabel!
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Check if any of the text fields are empty.
        if regUserTextField.text?.isEmpty ?? true ||
            regFirstNameTextField.text?.isEmpty ?? true ||
            regLastNameTextField.text?.isEmpty ?? true ||
            regPassTextField.text?.isEmpty ?? true {
            // If any text field is empty, show an error message.
            regResult.text = "All fields are required. Please fill out each field."
            regResult.isHidden = false
        } else {
            regResult.isHidden = true
            // Proceed with registration logic here.
            // This is where you might call a web service to register the user, etc.
            // On successful registration, you could transition to another view controller or reset the form as needed.
            //add user PHP file will be called here
            registerUser(username: regUserTextField.text ?? "",
                             firstName: regFirstNameTextField.text ?? "",
                             lastName: regLastNameTextField.text ?? "",
                             password: regPassTextField.text ?? "")
            regResult.text = "Registration made, please now go back and login"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        regResult.isHidden = true

        // Set the current view controller as the delegate for the text fields.
        regUserTextField.delegate = self
        regFirstNameTextField.delegate = self
        regLastNameTextField.delegate = self
        regPassTextField.delegate = self
        
        
        // Setup to dismiss the keyboard.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func constructRegisterURL(username: String, firstName: String, lastName: String, password: String) -> URL? {
        let baseURL = "https://student.csc.liv.ac.uk/~sgtbrett/phpwebservice/adduser.php"
        let queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "firstname", value: firstName),
            URLQueryItem(name: "lastname", value: lastName),
            URLQueryItem(name: "password", value: password)
        ]
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
    
    func registerUser(username: String, firstName: String, lastName: String, password: String) {
        guard let url = constructRegisterURL(username: username, firstName: firstName, lastName: lastName, password: password) else {
            print("Invalid URL for registration")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network request error during registration: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    // Update your UI here based on the response
                    self.regResult.text = responseString
                    self.regResult.isHidden = false
                    print("Registration response: \(responseString)")
                }
            }
        }
        
        task.resume()
    }
    

}
