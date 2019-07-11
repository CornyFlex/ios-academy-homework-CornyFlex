//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 06/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - properties
    
    private var tapCounter = 0
    
    // MARK: - outlets
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var stopAnimatingOutlet: UIButton!
    @IBOutlet private weak var numberOfTaps: UILabel!
    @IBOutlet private weak var centerButtonCounter: UIButton!
    @IBOutlet private weak var welcomeMessage: UILabel!
    @IBOutlet private weak var startAnimatingOutlet: UIButton!
    
    // MARK: - lifecycle methods
    
    private func configureUI() {
        centerButtonCounter.layer.cornerRadius = 25
        centerButtonCounter.layer.borderWidth = 5
        startAnimatingOutlet.layer.cornerRadius = 10
        startAnimatingOutlet.layer.borderWidth = 5
        stopAnimatingOutlet.layer.cornerRadius = 10
        stopAnimatingOutlet.layer.borderWidth = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        numberOfTaps.isHidden = true
        centerButtonCounter.isHidden = true
        stopAnimatingOutlet.isHidden = true
        startAnimatingOutlet.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.numberOfTaps.isHidden = false
            self.centerButtonCounter.isHidden = false
            self.stopAnimatingOutlet.isHidden = false
            self.startAnimatingOutlet.isHidden = false
        
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - actions
    
    @IBAction private func centerButtonCounterAction(_ sender: UIButton) {
        tapCounter += 1
        numberOfTaps.text = "Number of taps: \(tapCounter)"
    }
    
        //Moon - stop animating
    @IBAction private func stopAnimatingAction() {
        activityIndicator.stopAnimating()
    }
    
        //Game console - start animating
    @IBAction private func startAnimatingAction() {
        activityIndicator.startAnimating()
    }
}


