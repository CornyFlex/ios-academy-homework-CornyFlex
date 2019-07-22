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
    
    // MARK: - outlets
    
    @IBOutlet weak var tableViewShows: UITableView!
    
    // MARK: - properties
    
    var items = [Show]()
    var token: String!
//    let showInstance = HomeViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadShowsAlamofireCodable()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewShows.delegate = self
        tableViewShows.dataSource = self
        setupTableView()
        navigationItem.setHidesBackButton(true, animated: true)
//        navigationController?.setViewControllers([showInstance], animated: true)
        
    }
    
}
extension HomeViewController: UITableViewDelegate {
    // Delegate UI events, open up `UITableViewDelegate` and explore :)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
        
        let detailsStoryboard = UIStoryboard(name: "Details", bundle: nil)
        let detailsViewController = detailsStoryboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.idDetails = item.idShow
        detailsViewController.showDescription = item.description
        detailsViewController.tokenDetails = token
        detailsViewController.showTitle = item.title
        
        navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowsTableViewCell.self), for: indexPath) as! ShowsTableViewCell
            cell.configure(with: items[indexPath.row])
        
//        let something: Show
//        something = items[indexPath.row]
//
//        cell.titleTVShow.text = something.title
          return cell
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
                    shows.forEach { show in
                        self.items.append(show)
                    }
                    self.tableViewShows.reloadData()
                case .failure(let error):
                    print("Eror: \(error)")
                }
        }
    }
}

private extension HomeViewController {
    
    func setupTableView() {
        // For now we are using automatic height, that means that the table view cell will try to callculate its own size
        // For the system to knows that we plan to do that, we need to specifiy some estimated row height
        tableViewShows.estimatedRowHeight = 110
        //tableViewShows.rowHeight = UITableView.automaticDimension
        
        // Little trick to remove empty table view cells from the screen, play with removing it.
        tableViewShows.tableFooterView = UIView()
//
//        tableView.delegate = self
//        tableView.dataSource = self
    }
}

