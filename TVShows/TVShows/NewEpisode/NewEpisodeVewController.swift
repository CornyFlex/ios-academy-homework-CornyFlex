//
//  NewEpisodeVewController.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

protocol NewEpisodeDelegate: class {
    func episodeAdded()
    func episodeError()
}

class NewEpisodeViewController: UIViewController {

    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
    
    var showId: String = ""
    var tokenEpisode: String = ""
    weak var delegate: NewEpisodeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow)
        )
    }
    
    @objc func didSelectCancel() {
        print("Cancel Show")
        self.dismiss(animated: true)
    }
    
    @objc func didSelectAddShow() {
        addShowEpisode(ShowId: showId)
    }

}
private extension NewEpisodeViewController {
    func addShowEpisode(ShowId: String){
        
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId": ShowId,
            "title" : episodeTitleTextField.text!,
            "description": episodeDescriptionTextField.text!,
            "episodeNumber": episodeNumberTextField.text!,
            "season": seasonNumberTextField.text!,
            "mediaId": ""
        ]
        
        let headers = ["Authorization": tokenEpisode]
        
        Alamofire
        .request("https://api.infinum.academy/api/episodes",
        method: .post,
        parameters: parameters,
        encoding: JSONEncoding.default,
        headers: headers)
        
        .validate()
        .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<Episodes>) in
            
            SVProgressHUD.dismiss()
            
            switch response.result {
            case .success(let episodeAdded):
                print("Succes: \(episodeAdded)")
                self?.dismiss(animated: true)
                self?.delegate?.episodeAdded()
                
            case .failure(let error):
                print("API failure: \(error)")
                
                let alert = UIAlertController(title:"Failed to add episode", message: "Failed to add new episode, please try again. (Error: \(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"OK", style: .cancel, handler:nil))
                self?.present(alert, animated: true)
                
                self?.delegate?.episodeError()
            }
        }
    }
    }
