//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 06/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

class LoginViewController: UIViewController {
    
    // MARK - outlets:
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var clickToRememberCheckmark: UIButton!
    @IBOutlet private weak var rememberMe: UILabel!
    @IBOutlet private weak var clickToLogin: UIButton!
    @IBOutlet private weak var createAccount: UIButton!
    
    // MARK: - life cycle functions
    
    private func goToHomeScreen() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(viewController, animated: true)

    }
    
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
        let username = usernameField.text
        let password = passwordField.text
        
        if (username == "" || password == "") {
            return
        }
        
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        let username = usernameField.text
        let password = passwordField.text
        
        if (username == "" || password == "") {
            return
        }
        
        registerUserAlamofireCodableWith(user: username!, pass: password!)
    }
}
    
    // MARK: register and json parsing
    
    private extension LoginViewController {
        
        func registerUserAlamofireCodableWith(user: String, pass: String) {
            
            SVProgressHUD.show()
            
            let parameters: [String: String] = [
                "username": user,
                "password": pass
            ]
            
            Alamofire
                .request("https://api.infinum.academy/api/users",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<User>) in
                    
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let user):
                        print("Succes: \(user)")
                        self.goToHomeScreen()
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                    
                }
            }
        }
    

    
        
        



