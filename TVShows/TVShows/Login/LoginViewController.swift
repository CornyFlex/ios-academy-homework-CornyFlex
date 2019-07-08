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
    var count = 0
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var button_icon: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button_outlet: UIButton!
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var button_start_outlet: UIButton!
    
    @IBAction func button(_ sender: UIButton) {
        count += 1
        label.text = "Number of taps: \(count)"
    }
    //Game console - start animating
    @IBAction func button_icon_action(_ sender: Any) {
        Activity.stopAnimating()
    }
    //Moon - stop animating
    @IBAction func button_start_action(_ sender: Any) {
        Activity.startAnimating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        button_outlet.layer.cornerRadius = 25
        button_outlet.layer.borderWidth = 5
        button_start_outlet.layer.cornerRadius = 10
        button_start_outlet.layer.borderWidth = 5
        button_icon.layer.cornerRadius = 10
        button_icon.layer.borderWidth = 5
        
        
        label.isHidden = true
        button_outlet.isHidden = true
        button_icon.isHidden = true
        button_start_outlet.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
        
            self.label.isHidden = false
            self.button_outlet.isHidden = false
            self.button_icon.isHidden = false
            self.button_start_outlet.isHidden = false
        
            self.Activity.stopAnimating()
        })
    }
    
        
        
}


