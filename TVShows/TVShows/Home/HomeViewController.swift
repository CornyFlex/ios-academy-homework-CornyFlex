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

enum LayoutMode {
    case grid
    case list
}

class HomeViewController: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet weak var collectionViewHome: UICollectionView!
    
    // MARK: - properties
    
    var items = [Show]()
    var token: String!
    
    var collectionViewLayoutMode: LayoutMode = .list
    
    // MARK: - life cycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewHome.delegate = self
        collectionViewHome.dataSource = self
        loadShows()
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Image-7"),
            style: .plain,
            target: self,
            action: #selector(logoutActionHandler))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "goToGridView"),
            style: .plain,
            target: self,
            action: #selector(switchToGridView))
    }
    
    @objc private func logoutActionHandler() {
        print("Log OUT")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
        
        goToLogin()
    }
    
    @objc private func switchToGridView() {
        guard let layoutButton = navigationItem.rightBarButtonItem else {
            return
        }
        
        collectionViewLayoutMode = collectionViewLayoutMode == .grid ? .list : .grid
        
        let barButtonImage: UIImage?
        
        switch collectionViewLayoutMode {
        case .grid:
            barButtonImage = UIImage(named: "goToListView")
        case .list:
            barButtonImage = UIImage(named: "goToGridView")
        }
        
        layoutButton.image = barButtonImage
        
        collectionViewHome.reloadData()
        
    }
}

// MARK: - extensions

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        print("Selected Item: \(item)")
        
        let detailsStoryboard = UIStoryboard(name: "Details", bundle: nil)
        guard
        let detailsViewController = detailsStoryboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
            else { return }
        
        detailsViewController.idDetails = item.idShow
        detailsViewController.tokenDetails = token
        detailsViewController.showTitle = item.title
        detailsViewController.imageUrlDetails = item.imageUrl
        
        navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
}
    
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat
        
        switch collectionViewLayoutMode {
        case .grid:
            cellWidth = view.frame.width / 2
        case .list:
            cellWidth = view.frame.width
        }
        
        return CGSize(width: cellWidth, height: 200)
    }
    
}



extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowsCollectionViewCell.self), for: indexPath) as! ShowsCollectionViewCell
        
        
        if collectionViewLayoutMode == .grid {
            cell.configure(with: items[indexPath.row], layout: true)
        } else {
            cell.configure(with: items[indexPath.row], layout: false)
        }
          return cell
    }
    
}

//Mark: -private
    //Mark: -shows loading and parsing
private extension HomeViewController {
    func loadShows() {
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Show]>) in
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let shows):
                    print("Succes: \(shows)")
                    shows.forEach { show in
                        self?.items.append(show)
                    }
                    self?.collectionViewHome.reloadData()
                case .failure(let error):
                    print("Eror: \(error)")
                    
                }
        }
    }
}

private extension HomeViewController {
    func goToLogin() {
        let loginStoryboard = UIStoryboard(name: "Login", bundle:nil)
        
        guard
            let viewControllerForGoingBackToLogin = loginStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
            else { return }
        
        navigationController?.setViewControllers([viewControllerForGoingBackToLogin], animated: true)
    }
}


