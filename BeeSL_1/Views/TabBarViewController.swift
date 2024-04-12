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
                    break
                }
            }
        }
    }
}

