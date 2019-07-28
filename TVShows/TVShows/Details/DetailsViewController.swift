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
    
    @IBOutlet weak var descriptionDetailsShow: UITextView!
    @IBOutlet weak var nameSeriesDetails: UILabel!
    @IBOutlet weak var episodesNumberDetails: UILabel!
    @IBOutlet weak var thumbnailDetails: UIImageView!
    
    @IBOutlet weak var addNewShow: UIButton!
    
    @IBOutlet weak var tableViewDetails: UITableView!
    
    var tokenDetails: String!
    var idDetails: String!
    
    var showTitle: String!
    var showDescription: String?
    var numberOfEpisodes = 0
    var imageUrlDetails: String!
    
    var characteristics = [ShowDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    }
    
    func loadDetails() {
        loadDetailsShowAlamofireCodable(showId: idDetails)
        loadDescriptionDetailsShowAlamofireCodable(showId: idDetails)
        
        nameSeriesDetails.text = showTitle
        episodesNumberDetails.text = String(numberOfEpisodes)
        
        self.tableViewDetails.bringSubviewToFront(addNewShow)
        
        let url = URL(string: "https://api.infinum.academy" + imageUrlDetails)
        let placeHolder = UIImage(named: "Image-5")
        thumbnailDetails.kf.setImage(with: url, placeholder: placeHolder)
       
    }
    @IBAction func clickToAddNewEp() {
        let newEpStoryboard = UIStoryboard(name:"AddEpisode", bundle:nil)
        let newEpViewController = newEpStoryboard.instantiateViewController(withIdentifier: "NewEpisodeViewController") as! NewEpisodeViewController
        
        newEpViewController.showId = idDetails
        newEpViewController.tokenEpisode = tokenDetails
        
        newEpViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: newEpViewController)
        present(navigationController, animated: true)
    }
}

// MARK: - extensions

extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemDetails = characteristics[indexPath.row]
        print("\(itemDetails)")
        
        let episodeDetailsSB = UIStoryboard(name: "EpisodeDetails", bundle: nil)
        guard
        let episodeDetailsVC = episodeDetailsSB.instantiateViewController(withIdentifier: "EpisodeDetailsViewController") as? EpisodeDetailsViewController
            else { return }
        
        episodeDetailsVC.epDescription = itemDetails.description!
        episodeDetailsVC.epSeasonNumber = itemDetails.season!
        episodeDetailsVC.epNumber = itemDetails.episodeNumber!
        episodeDetailsVC.epTitleDetails = itemDetails.title
        
        navigationController?.pushViewController(episodeDetailsVC, animated: true)

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

// MARK: - private extension


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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[ShowDetails]>) in
                SVProgressHUD.dismiss()

                switch response.result {
                case .success(let showsDetails):
                    print("Success: \(showsDetails)")
                    
                    showsDetails.forEach { show in
                        self?.characteristics.append(show)
                    }
                    self?.episodesNumberDetails.text = "Number of episodes:\(showsDetails.count)"
                    self?.tableViewDetails.reloadData()
                  
                case .failure(let error):
                    print("Failed: \(error)")
                }
        }
    }
}

private extension DetailsViewController {
    func loadDescriptionDetailsShowAlamofireCodable(showId: String) {
        SVProgressHUD.show()
        
        let headers = ["Authorization": tokenDetails]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/\(showId)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: (headers as! HTTPHeaders)
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<ShowDetails>) in
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let showsDetails):
                    print("Success: \(showsDetails)")
                    self?.descriptionDetailsShow.text = showsDetails.description
                    self?.tableViewDetails.reloadData()
                    
                case .failure(let error):
                    print("Failed: \(error)")
                }
        }
    }
    
}
private extension DetailsViewController {
    func setupDetailsTable() {
        tableViewDetails.estimatedRowHeight = 70
        tableViewDetails.tableFooterView = UIView()
    }
}

// MARK: - extension delegate

extension DetailsViewController: NewEpisodeDelegate {
    func episodeAdded() {
        loadDetails()
    }
    func episodeError() {
    }
}
