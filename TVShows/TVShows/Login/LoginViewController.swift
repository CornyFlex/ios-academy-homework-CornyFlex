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
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeCheckmark: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    // MARK: - life cycle functions
    
    private func goToHomeScreen() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        guard
        let viewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func loginButtonEdit() {
        loginButton.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkmarkClicked()
        loginButtonEdit()
        
        rememberMeCheckmark.isSelected = false
    }
    
    // MARK: - actions
    
    @IBAction private func checkmarkClicked() {
        
        rememberMeCheckmark.isSelected.toggle()
    }
    
    @IBAction func loginClicked() {
        
        guard
            let email = usernameTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            let alert = UIAlertController(title: "Login error",  message: "Please enter username and password", preferredStyle: .alert)
            return
        }
        
        loginUserWith(email: email, pass: password)
    }
    
    @IBAction func clickToCreateAccount() {
        
        guard
            let email = usernameTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
            
        else {
            let alert = UIAlertController(title: "Registration error",  message: "Please enter username and password", preferredStyle: .alert)
            navigationController?.present(alert, animated: true)
            return
        }
        
        registerUserWith(email: email, pass: password)
    }
}
// MARK: - private

    // MARK: - register and json parsing (going to login)
    
    private extension LoginViewController {
        
        func registerUserWith(email: String, pass: String) {
            
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
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<User>) in
                    
                    SVProgressHUD.dismiss()
                    
                    switch response.result {
                    case .success(let user):
                        
                        print("Succes: \(user)")
                        self?.loginUserWith(email: email, pass: pass)
                        
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                }
            }
    }

// MARK: Login and json parsing (going to home screen)

    private extension LoginViewController {
    
        func loginUserWith(email: String, pass: String) {
            
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
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<LoginData>) in
                    
                    SVProgressHUD.dismiss()
                    
                    switch response.result {
                        
                    case .success(let user):
                        print("Succes: \(user)")
                        self?.goToHomeScreen()
                        
                    case .failure(let error):
                        print("API failure: \(error)")
                }
            }
        }
    }
    
        
        



