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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DetailsTableViewCell {
    func configureDetailsCell(with item: ShowDetails) {
        seasonNumberDetails.text = "S\(item.season)"
        episodeTitleSeries.text = item.title
        episodeNumberDetails.text = "Ep\(item.episodeNumber)"
        
    }
}
