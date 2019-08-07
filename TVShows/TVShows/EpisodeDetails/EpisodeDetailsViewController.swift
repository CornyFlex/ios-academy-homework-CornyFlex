//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 28/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class EpisodeDetailsViewController: UIViewController {

    // MARK: - outlets
    
    @IBOutlet weak var goToCommentsButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var episodeDetailsImage: UIImageView!
    @IBOutlet weak var episodeDetailsTitle: UILabel!
    @IBOutlet weak var episodeDetailsSeasonAndEpisodeNumber: UILabel!
    @IBOutlet weak var episodeDetailsDescription: UITextView!
    
    // MARK: - properties
    
    var epId = ""
    var token = ""
    
    var epImageUrl = ""
    var epTitleDetails = ""
    var epSeasonNumber = ""
    var epNumber = ""
    var epDescription = ""
    
    let barButtonImage = UIImage(named: "navigateBack")
    let disposeBag = DisposeBag()
    
    // MARK: - lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEpisodeDetails()
        loadEpisodeDetailsEvents()
    }
    
    func loadEpisodeDetails() {
        episodeDetailsDescription.text = epDescription
        episodeDetailsTitle.text = epTitleDetails
        episodeDetailsSeasonAndEpisodeNumber.text = "S\(epSeasonNumber) Ep\(epNumber)"
        
        let url = URL(string: "https://api.infinum.academy\(epImageUrl)")
        let placeHolder = UIImage(named: "placeholderAlpha")
        
        episodeDetailsImage.kf.setImage(with: url, placeholder: placeHolder)
    }
    
    func goToAddComments() {
        let commentsSB = UIStoryboard(name: "Comments", bundle: nil)
        
        guard
            let commentsVC = commentsSB.instantiateViewController(withIdentifier: "LoadCommentsViewController") as? LoadCommentsViewController
            else { return }
        
        commentsVC.episodeID = epId
        navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    func loadEpisodeDetailsEvents() {
        
        goBackButton.rx.tap
        .asObservable()
        .subscribe(onNext: { [unowned self] _ in
            self.dismiss(animated: true, completion:nil)
        })
        .disposed(by: disposeBag)
        
        goToCommentsButton.rx.tap
        .asObservable()
        .subscribe(onNext: { [unowned self] _ in
            self.goToAddComments()
        })
        .disposed(by: disposeBag)
        
    }
}

