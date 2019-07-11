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
    
    @IBOutlet weak var username_outlet: UITextField!
    @IBOutlet weak var password_outlet: UITextField!
    @IBOutlet weak var checkmark_outlet: UIButton!
    @IBOutlet weak var remember_outlet: UILabel!
    @IBOutlet weak var login_outlet: UIButton!
    @IBOutlet weak var create_outlet: UIButton!
    @IBOutlet weak var or_outlet: UILabel!
    
    // MARK: - life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        }
    
    // MARK: - actions
    
    @IBAction func checkmark_action(_ sender: UIButton) {
        if checkmark_outlet.currentImage == UIImage(named: "ic-checkbox-empty.png") {
            checkmark_outlet.setImage(UIImage(named: "ic-checkbox-filled.png"), for: .normal)
        }
        else {
            checkmark_outlet.setImage(UIImage(named: "ic-checkbox-empty.png"), for: .normal)
        }
    }
}
    
        
        



