//
//  TabBarViewController.swift
//  BeeSL_1
//
//  Created by Joe Taylor on 11/04/2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passUserToProfileVC()
    }
    
    func passUserToProfileVC() {
        if let viewControllers = viewControllers {
            for viewController in viewControllers {
                if let profileVC = viewController as? ProfileViewController {
                    profileVC.user = user
                    print("User passed to ProfileVC: \(String(describing: user?.username))") // Debug statement
                    break
                }
                if let quizOptionVC = viewController as? QuizOptionViewController {
                    quizOptionVC.user = user
                    print("User passed to quizoptionVC: \(String(describing: user?.username))") // Debug statement
                    break
                }
                if let gameVC = viewController as? GameViewController {
                    gameVC.user = user
                    print("User passed to gameVC: \(String(describing: user?.username))") // Debug statement
                    break
                }
                if let game2VC = viewController as? Game2ViewController {
                    game2VC.user = user
                    print("User passed to game2VC: \(String(describing: user?.username))") // Debug statement
                    break
                }
                if let game3VC = viewController as? Game3ViewController {
                    game3VC.user = user
                    print("User passed to game3VC: \(String(describing: user?.username))") // Debug statement
                    break
                }
            }
        }
    }
}

