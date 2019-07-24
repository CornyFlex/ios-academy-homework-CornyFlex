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

    let defaults = UserDefaults.standard
    
    // MARK: - outlets
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var clickToRememberCheckmark: UIButton!
    @IBOutlet private weak var clickToLogin: UIButton!
    @IBOutlet private weak var clickToCreateAccount: UIButton!
    
    // MARK: - life cycle functions
    
    private func goToHomeScreen(token: String) {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        viewController.token = token
        navigationController?.setViewControllers([viewController], animated: true)
        
    }
    
    private func loginButtonEdit() {
        clickToLogin.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.black)
        clickToRememberCheckmark.isSelected = false
        loginButtonEdit()
        
        if userAlreadyExist(userNameKey: "email", passwordKey: "password") == true {
            loginUserAlamofireCodableWith(email: defaults.string(forKey:"email")!, pass: defaults.string(forKey: "password")!)
        }
    }
    
    // MARK: - actions
    
    @IBAction private func checkmarkClicked() {
        clickToRememberCheckmark.isSelected.toggle()
    }
    
    @IBAction func loginClicked() {
        guard let email = usernameField.text else {
            print("Error username")
            return
        }
        
        guard let password = passwordField.text else {
            print("Error password")
            return
        }
        
        if (email == "" || password == "") {
            return
        }
        
        loginUserAlamofireCodableWith(email: email, pass: password)
    }
    
    @IBAction func createAccountClicked() {
        
        guard let email = usernameField.text else {
            print("Error username")
            return
        }
        guard let password = passwordField.text else {
            print("Error password")
            return
        }
        
        if (email == "" || password == "") {
            return
        }
        
        registerUserAlamofireCodableWith(email: email, pass: password)
    }
}
// MARK: - private
    // MARK: - register and json parsing (going to login)
    
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
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<User>) in
                    
                    SVProgressHUD.dismiss()
                    
                    switch response.result {
                    case .success(let user):
                        print("Succes: \(user)")
                        self?.loginUserAlamofireCodableWith(email: email, pass: pass)
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                }
            }
        }

// MARK: Login and json parsing (going to home screen)

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
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<LoginData>) in
                    
                    SVProgressHUD.dismiss()
                    
                    switch response.result {
                        
                    case .success(let user):
                        print("Succes: \(user)")
                        if self?.clickToRememberCheckmark.isSelected == true {
                            
                            self?.defaults.set(email, forKey: "email")
                            self?.defaults.set(pass, forKey: "password")
                        }
                        self?.goToHomeScreen(token: user.token)
                        
                    case .failure(let error):
                        print("API failure: \(error)")
                        
                        self?.passwordField.shake()
                        self?.usernameField.shake()
                        
                        let alert = UIAlertController(title:"Login failed", message: "Error: Incorrect email or password, please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title:"OK", style: .cancel, handler:nil))
                        self?.present(alert, animated: true)
                    }
        }
    }
}
private extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}

private extension LoginViewController {
    func userAlreadyExist(userNameKey: String, passwordKey: String) -> Bool {
        return defaults.string(forKey: userNameKey) != nil && defaults.string(forKey: passwordKey) != nil
    }
}
//private extension LoginViewController {
//    func saveUserInfo() {
//        defaults.set(usernameField.text, forKey: "email")
//        defaults.set(passwordField.text, forKey: "password")
//    }
//}




