//
//  DetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 21/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var nameSeriesDetails: UILabel!
    @IBOutlet weak var episodesNumberDetails: UILabel!
    @IBOutlet weak var descriptionDetails: UITextView!
    @IBOutlet weak var thumbnailDetails: UIImageView!
    
    var tokenDetails: String!
    var idDetails: String!
    
    var showTitle: String!
    var showDescription: String?
    
    var characteristics = [ShowDetails]()
    
    @IBOutlet weak var tableViewDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadDetailsShowAlamofireCodable(showId: idDetails)
        descriptionDetails.text = showDescription
        nameSeriesDetails.text = showTitle
    }
}
extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let itemDetails = characteristics[indexPath.row]
        print("\(itemDetails)")
        
        
//        loadDetailsShowAlamofireCodable(showId: idDetails)
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as! DetailsTableViewCell
        cell.configureDetailsCell(with: characteristics[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
}




private extension DetailsViewController {
    func loadDetailsShowAlamofireCodable(showId: String) {
        SVProgressHUD.show()
        
        let headers = ["Authorization": tokenDetails]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/\(showId)/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: (headers as! HTTPHeaders)
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<[ShowDetails]>) in
                SVProgressHUD.dismiss()

                switch response.result {
                case .success(let showsDetails):
                    print("Success: \(showsDetails)")
                    
                    showsDetails.forEach { show in
                        self.characteristics.append(show)
                    }
                    self.tableViewDetails.reloadData()
                  

                    
                case .failure(let error):
                    print("Failed: \(error)")
                }
        }
    }
}
