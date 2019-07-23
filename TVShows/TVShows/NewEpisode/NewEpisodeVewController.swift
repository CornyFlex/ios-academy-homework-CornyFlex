//
//  NewEpisodeVewController.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

class NewEpisodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow)
        )
    }
    
    @objc func didSelectCancel() {
        print("Cancel Show")
        _ = self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAddShow() {
        print("Add Show")
    }

}
