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
        if (textFieldUser.text == "" || textFieldPass.text == "") {
            loginResult.text = "Username or password required please.."
        }
        else {
            //after login is completed, may want to put login web service is compltete here
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
        

    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldUser.delegate = self
        textFieldPass.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
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
