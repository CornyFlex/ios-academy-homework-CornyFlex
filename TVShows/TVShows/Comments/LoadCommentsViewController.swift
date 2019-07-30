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
    
    @IBOutlet weak var inputCommentTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let emailUserComments = UserDefaults.standard.string(forKey: "email")
    let idUserComments = UserDefaults.standard.string(forKey: "token")
    
    var episodeID = ""
    
    var commentsList = [Comment]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToEpDetails))
        
        navigationItem.leftBarButtonItem?.image = UIImage(named:"navigateBack")
        
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
        
        tableViewComments.rowHeight = UITableView.automaticDimension
        tableViewComments.estimatedRowHeight = 400
        
    }
    
   @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            bottomConstraint.constant = keyboardSize.height - view.safeAreaInsets.bottom
            }
        }

   @objc func keyboardWillHide(notification: Notification) {
    if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            bottomConstraint.constant = 0
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
    
    func postEpisodeCommentWith(text: String, episodeID: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "text": text,
            "episodeId": episodeID
        ]
        
        let headers = ["Authorization": idUserComments]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/comments",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: (headers as! HTTPHeaders)
            )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<PostComment>) in
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
        postEpisodeCommentWith(text: inputCommentTextField.text!, episodeID: episodeID)
        inputCommentTextField.text = ""
    }
    
}
extension LoadCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        let commentDetails = commentsList[indexPath.row]
        print("\(commentDetails)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

}

