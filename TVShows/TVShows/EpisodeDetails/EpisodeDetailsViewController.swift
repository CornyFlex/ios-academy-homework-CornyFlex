//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 28/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodeDetailsDescription.text = epDescription
        episodeDetailsTitle.text = epTitleDetails
        episodeDetailsSeasonAndEpisodeNumber.text = "S\(epSeasonNumber) Ep\(epNumber)"
        // Do any additional setup after loading the view.
    }
    

    @IBAction func didClickOnCommentsButton() {
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
