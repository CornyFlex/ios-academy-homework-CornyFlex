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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button_outlet: UIButton!
    @IBAction func button(_ sender: UIButton) {
        count += 1
        label.text = "Number of taps: \(count)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        button_outlet.layer.cornerRadius = 5
        button_outlet.layer.borderWidth = 1
    }
}

