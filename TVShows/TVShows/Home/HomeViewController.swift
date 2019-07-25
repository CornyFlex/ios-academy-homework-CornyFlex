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
import Kingfisher

class HomeViewController: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet weak var tableViewShows: UITableView!
    
    // MARK: - properties
    
    var items = [Show]()
    var token: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewShows.delegate = self
        tableViewShows.dataSource = self
        setupTableView()
        loadShowsAlamofireCodable()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Image-7"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(logoutActionHandler))
    }
    
    @objc private func logoutActionHandler() {
        print("hello")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.synchronize()
        
        goToLogin()
    }
}

private extension HomeViewController {
    func goToLogin() {
        let loginStoryboard = UIStoryboard(name: "Login", bundle:nil)
        let viewControllerForGoingBackToLogin = loginStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        
        navigationController?.setViewControllers([viewControllerForGoingBackToLogin], animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
        
        let detailsStoryboard = UIStoryboard(name: "Details", bundle: nil)
        let detailsViewController = detailsStoryboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        detailsViewController.idDetails = item.idShow
        detailsViewController.tokenDetails = token
        detailsViewController.showTitle = item.title
        detailsViewController.imageUrlDetails = item.imageUrl
        
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
        tableViewShows.estimatedRowHeight = 110
        tableViewShows.tableFooterView = UIView()
        tableViewShows.separatorStyle = .none
    }
}

