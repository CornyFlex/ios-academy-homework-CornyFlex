//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 28/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import Kingfisher

class EpisodeDetailsViewController: UIViewController {

    @IBOutlet weak var episodeDetailsImage: UIImageView!
    @IBOutlet weak var episodeDetailsTitle: UILabel!
    @IBOutlet weak var episodeDetailsSeasonAndEpisodeNumber: UILabel!
    @IBOutlet weak var episodeDetailsDescription: UITextView!
    
    var epImageUrl = ""
    var epTitleDetails = ""
    var epSeasonNumber = ""
    var epNumber = ""
    var epDescription = ""
    
    let barButtonImage = UIImage(named: "navigateBack")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEpisodeDetails()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            image: barButtonImage,
//            style: .plain,
//            target: self,
//            action: #selector(didSelectCancel))
//    }
//
//    @objc func didSelectCancel() {
//        print("Cancel Episode")
//        navigationController?.dismiss(animated: true, completion: nil)
//    }
    }
    func loadEpisodeDetails() {
        episodeDetailsDescription.text = epDescription
        episodeDetailsTitle.text = epTitleDetails
        episodeDetailsSeasonAndEpisodeNumber.text = "S\(epSeasonNumber) Ep\(epNumber)"
        
        let url = URL(string: "https://api.infinum.academy\(epImageUrl)")
        let placeHolder = UIImage(named: "placeholderEpisodeDetails")
        
        episodeDetailsImage.kf.setImage(with: url, placeholder: placeHolder)
    }
    
    
    @IBAction func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didClickOnCommentsButton() {
        let commentsSB = UIStoryboard(name: "Comments", bundle: nil)
        guard
            let commentsVC = commentsSB.instantiateViewController(withIdentifier: "LoadCommentsViewController") as? LoadCommentsViewController
            else { return }
        
        navigationController?.pushViewController(commentsVC, animated: true)
        
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
