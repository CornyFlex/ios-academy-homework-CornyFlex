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
    
    @IBAction func loginClicked() {
        guard let username = usernameField.text else {
            print("Error username")
            return
        }
        guard let password = passwordField.text else {
            print("Error password")
            return
        }
        
        if (username == "" || password == "") {
            return
        }
        loginUserAlamofireCodableWith(email: username, pass: password)
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        
        guard let username = usernameField.text else {
            print("Error username")
            return
        }
        guard let password = passwordField.text else {
            print("Error password")
            return
        }
        
        if (username == "" || password == "") {
            return
        }
        registerUserAlamofireCodableWith(email: username, pass: password)
    }
}
    
    // MARK: - register and json parsing
    
    private extension LoginViewController {
        
        func registerUserAlamofireCodableWith(email: String, pass: String) {
            
            SVProgressHUD.show()
            
            let parameters: [String: String] = [
                "email": email,
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
                        self.loginUserAlamofireCodableWith(email: email, pass: pass)
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                }
            }
        }

// MARK: - extensions

    private extension LoginViewController {
    
        func loginUserAlamofireCodableWith(email: String, pass: String) {
            
            SVProgressHUD.show()
            
            let parameters: [String: String] = [
                "email": email,
                "password": pass
            ]
            
            Alamofire
                .request("https://api.infinum.academy/api/users/sessions",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<LoginData>) in
                    
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
    
        
        



