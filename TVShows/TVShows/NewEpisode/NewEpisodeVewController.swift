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
import Photos

// MARK: - protocol

protocol NewEpisodeDelegate: class {
    func episodeAdded()
    func episodeError()
}

class NewEpisodeViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - outlet
    
    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
    @IBOutlet weak var episodeAddPhotoButton: UIButton!
    
    // MARK: - properties
    
    var showId: String = ""
    var tokenEpisode: String = ""
    weak var delegate: NewEpisodeDelegate?
    let imagePicker = UIImagePickerController()
    
    var imageGallery: UIImage!
    
    // MARK: - lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        checkPermission()
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
        uploadImageOnAPI(token: tokenEpisode)
    }

    // MARK: - actions
    
    @IBAction func didTapAddPhotoButton() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        navigationController?.present(imagePicker, animated: true, completion: nil)
        
    }

    // MARK: - check permission
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        @unknown default:
            fatalError()
        }
    }
}
    
    
// MARK: - private extensions

private extension NewEpisodeViewController {
    func uploadImageOnAPI(token: String) {
        
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        let someUIImage = imageGallery
        let imageByteData = (someUIImage?.pngData()!)!
        
        Alamofire
            .upload(multipartFormData: { multipartFormData in multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
            method: .post,
            headers: headers)
            { [weak self] result in
                
                switch result {
                case .success(let uploadRequest, _, _):
                    print(uploadRequest)
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
    }
    
    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { [weak self] (response:
                DataResponse<Media>) in
                
                SVProgressHUD.dismiss()
                switch response.result {
                    case .success(let media):
                        print("DECODED: \(media)")
                        print("Proceed to add episode call...")
                        self?.addShowEpisode(ShowId: self!.showId, mediaId: media.id)
                    case .failure(let error):
                        print("FAILURE: \(error)")
    
                }
        }
    }
}

private extension NewEpisodeViewController {
    func addShowEpisode(ShowId: String, mediaId: String){
        
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId": ShowId,
            "title" : episodeTitleTextField.text!,
            "description": episodeDescriptionTextField.text!,
            "episodeNumber": episodeNumberTextField.text!,
            "season": seasonNumberTextField.text!,
            "mediaId": mediaId
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

// MARK: - extension delegate

extension NewEpisodeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageGallery = pickedImage
        episodeAddPhotoButton.setBackgroundImage(pickedImage, for: UIControl.State.normal)
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


