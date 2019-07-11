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
    
    @IBOutlet private weak var usernameOutlet: UITextField!
    @IBOutlet private weak var passwordOutlet: UITextField!
    @IBOutlet private weak var checkmarkOutlet: UIButton!
    @IBOutlet private weak var rememberMeOutlet: UILabel!
    @IBOutlet private weak var loginOutlet: UIButton!
    @IBOutlet private weak var createAccountOutlet: UIButton!
    @IBOutlet private weak var orOutlet: UILabel!
    
    // MARK: - life cycle functions
    
    private func loginButtonEdit() {
        loginOutlet.layer.cornerRadius = 20
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkmark_action()
        loginButtonEdit()
        }
    
    // MARK: - actions
    
    @IBAction private func checkmark_action() {
        if checkmarkOutlet.currentImage == UIImage(named: "ic-checkbox-empty.png") {
            checkmarkOutlet.setImage(UIImage(named: "ic-checkbox-filled.png"), for: .normal)
        }
        else {
            checkmarkOutlet.setImage(UIImage(named: "ic-checkbox-empty.png"), for: .normal)
        }
    }
}
    
        
        



