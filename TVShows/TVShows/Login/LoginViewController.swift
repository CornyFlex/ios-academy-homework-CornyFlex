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
import RxCocoa
import RxSwift
import TransitionButton

class LoginViewController: UIViewController {

    let defaults = UserDefaults.standard
    let disposeBag = DisposeBag()
    
    // MARK: - outlets
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var rememberMeCheckmark: UIButton!
    @IBOutlet private weak var loginButton: TransitionButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    // MARK: - life cycle functions
    
    private func goToHomeScreen(token: String) {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        guard
        let viewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            else { return }
        viewController.token = token
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    private func loginButtonEdit() {
        loginButton.layer.cornerRadius = 10
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editLoginUI()
        loginAndRegisterEvents()
        checkIfUserExists()
    }

    
    func confirmButtonValid(username: Observable<String>, password: Observable<String>) -> Observable<Bool> {
        return Observable.combineLatest(username, password)
        { (username, password) in
            return username.count > 0
                && password.count > 0
        }
    }
    
    func editLoginUI() {
        SVProgressHUD.setDefaultMaskType(.black)
        rememberMeCheckmark.isSelected = false
        loginButtonEdit()
    }
    
    
    func loginAndRegisterEvents() {
        
        let buttonColorEnabled = UIColor(red: 255.0/255.0, green: 117.0/255.0, blue: 140.0/255.0, alpha: 1)
        let username = usernameField.rx.text.orEmpty.asObservable()
        let password = passwordField.rx.text.orEmpty.asObservable()
        
        confirmButtonValid(username: username, password: password)
            .bind(to: loginButton.rx.isEnabled, createAccountButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        confirmButtonValid(username: username, password: password)
            .map { $0 ? buttonColorEnabled : UIColor.gray }
            .map { $0.withAlphaComponent(0.9) }
            .do(onNext: {[weak createAccountButton] in createAccountButton?.setTitleColor($0, for: [.normal, .disabled])})
            .bind(to: loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        let userNameAndPass = Observable.combineLatest(username, password)
    
        loginButton.rx.tap
            .asObservable()
            .do(onNext: {
                self.loginButton.startAnimation()
            })
            .withLatestFrom(userNameAndPass)
            .subscribe(onNext: { [unowned self] (email, password) in
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                backgroundQueue.async(execute: {
                self.loginUserWith(email: email, pass: password)
                }
            )})
            .disposed(by: disposeBag)
        
        
        createAccountButton.rx.tap
            .asObservable()
            .do(onNext: {
                self.loginButton.startAnimation()
            })
            .withLatestFrom(userNameAndPass)
            .subscribe(onNext: { [unowned self] (email, password) in
                self.registerUserWith(email: email, pass: password)
            })
            .disposed(by: disposeBag)
        
        rememberMeCheckmark.rx.tap
            .map { [unowned self] in !self.rememberMeCheckmark.isSelected }
            .bind(to: rememberMeCheckmark.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    func checkIfUserExists() {
        if userAlreadyExist(userNameKey: "email", passwordKey: "password") == true {
            loginUserWith(email: defaults.string(forKey:"email")!, pass: defaults.string(forKey: "password")!)
        }
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
                        self?.passwordField.shake()
                        self?.usernameField.shake()
                        
                         self?.loginButton.stopAnimation(animationStyle: .shake, completion: nil)
                    }
                }
            }
    }

// MARK: Login and json parsing (going to home screen)

    private extension LoginViewController {
    
        func loginUserWith(email: String, pass: String) {
            
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
                    
                    switch response.result {
                        
                    case .success(let user):
                        print("Succes: \(user)")
                        if self?.rememberMeCheckmark.isSelected == true {
        
                            self?.defaults.set(pass, forKey: "password")
                            self?.defaults.synchronize()
                        }
                        self?.defaults.set(email, forKey: "email")
                        self?.defaults.set(user.token, forKey: "token")
                        self?.defaults.synchronize()
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            self?.loginButton.stopAnimation(animationStyle: .expand, completion: {
                                    self?.goToHomeScreen(token: user.token)
                            })
                        })
                        
                    case .failure(let error):
                        print("API failure: \(error)")
                        self?.loginButton.stopAnimation(animationStyle: .shake, completion: nil)
                        self?.passwordField.shake()
                        self?.usernameField.shake()
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




