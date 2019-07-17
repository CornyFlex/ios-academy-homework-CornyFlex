//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 13/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
//Mark: -private
    //Mark: -shows loading and parsing
extension HomeViewController {
    func loadShowsAlamofireCodable(token: String) {
        SVProgressHUD.show()
        let headers = ["Authorization:": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        )
        
        
        
    }
}


