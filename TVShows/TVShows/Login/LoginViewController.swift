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
    @IBAction func button(_ sender: UIButton) {
        count += 1
        label.text = "Number of taps: \(count)"
    }
}

