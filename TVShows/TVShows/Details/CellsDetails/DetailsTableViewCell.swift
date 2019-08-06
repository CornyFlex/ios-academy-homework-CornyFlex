//
//  DetailsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 21/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var seasonNumberDetails: UILabel!
    @IBOutlet weak var episodeTitleSeries: UILabel!
    @IBOutlet weak var rightArrowSeries: UIImageView!
    @IBOutlet weak var episodeNumberDetails: UILabel!

}
extension DetailsTableViewCell {
    
    func configureDetailsCell(with item: ShowDetails) {
        episodeTitleSeries.text = item.title
        
        let season = item.season ?? "0"
        let episodeNumber = item.episodeNumber ?? "0"
        
        seasonNumberDetails.text = "S\(season)"
        episodeNumberDetails.text = "Ep\(episodeNumber)"
        
    }
}

