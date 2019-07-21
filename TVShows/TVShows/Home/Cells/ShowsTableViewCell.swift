//
//  ShowsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 19/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class ShowsTableViewCell: UITableViewCell {

    // MARK: - private UI elements
    @IBOutlet weak var thumbnailTVShow: UIImageView!
    @IBOutlet weak var titleTVShow: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        thumbnailTVShow.image = nil
//        titleTVShow.text = nil
    }
}

extension ShowsTableViewCell {
    func configure(with item: Show) {
        titleTVShow.text = item.title
    }
}

