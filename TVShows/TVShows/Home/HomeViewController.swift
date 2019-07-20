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
    
    var token: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadShowsAlamofireCodable()
    }
    
}
//Mark: -private
    //Mark: -shows loading and parsing
private extension HomeViewController {
    func loadShowsAlamofireCodable() {
        SVProgressHUD.show()
        
        let headers = ["Authorization": token!]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<[Show]>) in
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let shows):
                    print("Succes: \(shows)")
                case .failure(let error):
                    print("Eror: \(error)")
                
        }
    }
}
}

