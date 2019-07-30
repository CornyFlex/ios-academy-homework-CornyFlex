//
//  LoadCommentsViewController.swift
//  TVShows
//
//  Created by Infinum on 28/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class LoadCommentsViewController: UIViewController {
    
    @IBOutlet weak var tableViewComments: UITableView!
    
    let emailUserComments = UserDefaults.standard.string(forKey: "email")
    let idUserComments = UserDefaults.standard.string(forKey: "token")
    
    var episodeID = ""
    
    var commentsList = [Comment]()
    
//    let center = NotificationCenter.default
//
//    let keyboardWillShowObserver: NSObjectProtocol = center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
//        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let height = value.cgRectValue.height
//        if self.view.frame.origin.y == 0{
//            self.view.frame.origin.y -= height
//        }
    
//
//        // use the height of the keyboard to layout your UI so the prt currently in
//        // foxus remains visible
//    }
//
//    let keyboardWillHideObserver: NSObjectProtocol = self.center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y += height
//        }
//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back"
            , style: .plain, target: self, action: #selector(goBackToEpDetails))
    }
    
    @objc func goBackToEpDetails() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEpisodeComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoadCommentsViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoadCommentsViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
   @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }

    }

   @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    
    func getEpisodeComments() {
        SVProgressHUD.show()
        
        let headers = ["Authorization": idUserComments]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes/\(episodeID)/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: (headers as! HTTPHeaders)
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Comment]>) in
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let comments):
                    print("Success: \(comments)")
                    
                    self?.commentsList = comments
                    self?.tableViewComments.reloadData()
                    
                case .failure(let error):
                    print("Failed: \(error)")
                }
        }
    }
    
    func postEpisodeComment(text: String, episodeID: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "text": text,
            "episodeId": episodeID
        ]
        
        let headers = ["Authorization": idUserComments]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/\(episodeID)/episodes",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: (headers as! HTTPHeaders)
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Comment]>) in
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let success):
                    print("Success \(success)")
                    
                case .failure(let error):
                    print("Failed: \(error)")
                }
        }
    }
    
    
    @IBAction func didTapPostComment() {
    }
    
}
extension LoadCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let commentDetails = commentsList[indexPath.row]
        print("\(commentDetails)")
            
    }
}
    
extension LoadCommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH FOR COMMENTS BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.configureComment(with: commentsList[indexPath.row])
        
        return cell
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoadCommentsViewController: UITextViewDelegate {
    
}
