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
    
    // MARK: - outlet
    
    @IBOutlet weak var tableViewComments: UITableView!
    @IBOutlet weak var inputCommentTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageThatShowsIfThereAreNoComments: UIImageView!
    @IBOutlet weak var labelThatShowsIfThereAreNoComments: UILabel!
    
    // MARK: - properties
    
    let emailUserComments = UserDefaults.standard.string(forKey: "email")
    let idUserComments = UserDefaults.standard.string(forKey: "token")
    
    var episodeID = ""
    
    var commentsList = [Comment]()
    
    var refreshControl: UIRefreshControl?
    
    // MARK: - lifecycle functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToEpDetails))
        
        navigationItem.leftBarButtonItem?.image = UIImage(named:"navigateBack")
        
        imageThatShowsIfThereAreNoComments.image = UIImage(named: "placeholderEmpty")
        
        
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
        addRefreshControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoadCommentsViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoadCommentsViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableViewComments.rowHeight = UITableView.automaticDimension
        tableViewComments.estimatedRowHeight = 200
        
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

   func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableViewComments.refreshControl = refreshControl
    }
    
    @objc func refreshTable() {
        getEpisodeComments()
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
                    self?.refreshControl?.endRefreshing()
                    self?.tableViewComments.reloadData()
                    
                    
                    if self?.commentsList.count == 0 {
                        self?.tableViewComments.isHidden = true
                    }
                    
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
                    self?.tableViewComments.isHidden = false
                    self?.getEpisodeComments()
                    
                    
                case .failure(let error):
                    print("Failed: \(error)")
                }
        }
    }
    
    func deleteComment(with commentId: String, commentsListIndex: IndexPath) {
        SVProgressHUD.show()
        let headers = ["Authorization": idUserComments]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/comments/\(commentId)",
                method: .delete,
                encoding: JSONEncoding.default,
                headers: (headers as! HTTPHeaders)
            )
            .validate()
            .responseData { [weak self] response in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let success):
                    print("Success \(success)")
                    self?.tableViewComments.beginUpdates()
                    self?.commentsList.remove(at: commentsListIndex.row)
                    self?.tableViewComments.deleteRows(at: [commentsListIndex], with: UITableView.RowAnimation.none)
                    self?.tableViewComments.endUpdates()
                    
                case .failure(let error):
                    print("Error \(error)")
                }
            }
    }
    // MARK: - actions
    
    @IBAction func didTapPostComment() {
        postEpisodeCommentWith(text: inputCommentTextField.text!, episodeID: episodeID)
        inputCommentTextField.text = ""
    }
    
}

// MARK: - extensions

extension LoadCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let commentDetails = commentsList[indexPath.row]
        
        print("\(commentDetails)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var deleteAction = UITableViewRowAction(style: .default, title: "Delete") { [weak self] _,_ in
            let commentID = self?.commentsList[indexPath.row].userId
            
            self?.deleteComment(with: commentID!, commentsListIndex: indexPath)
            //handle delete
        }
        
        return [deleteAction]
    }
//    func tableView(tableView: UITableView!, commitEditingStyle editingStyle:   UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: IndexPath) {
//        if (editingStyle == UITableViewCell.EditingStyle.delete) {
//            tableViewComments.beginUpdates()
////            Names.removeAtIndex(indexPath!.row)
//            tableViewComments.deleteRows(at: [indexPath], with: UITableView.RowAnimation.none)
//            tableViewComments.endUpdates()
//
//        }
//    }
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

