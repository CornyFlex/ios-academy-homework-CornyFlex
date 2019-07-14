//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 06/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController {
    
    // MARK - outlets:
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var clickToRememberCheckmark: UIButton!
    @IBOutlet private weak var rememberMe: UILabel!
    @IBOutlet private weak var clickToLogin: UIButton!
    @IBOutlet private weak var createAccount: UIButton!
    
    // MARK: - life cycle functions
    
    private func loginButtonEdit() {
        clickToLogin.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkmark_action()
        loginButtonEdit()
        
        }
    
    // MARK: - actions
    
    @IBAction private func checkmark_action() {
        if clickToRememberCheckmark.currentImage == UIImage(named: "ic-checkbox-empty.png") {
            clickToRememberCheckmark.setImage(UIImage(named: "ic-checkbox-filled.png"), for: .normal)
        }
        else {
            clickToRememberCheckmark.setImage(UIImage(named: "ic-checkbox-empty.png"), for: .normal)
        }
    }
    @IBAction func loginClicked(_ sender: UIButton) {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        //viewController.name("iOS Academy 2019")
        
        navigationController?.pushViewController(viewController, animated: true)
        
        
        
    }
    @IBAction func createAccountClicked(_ sender: UIButton) {
    }
    
}
    
        
        



