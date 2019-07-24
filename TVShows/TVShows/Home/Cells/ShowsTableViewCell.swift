//
//  ShowsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 19/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import Kingfisher

class ShowsTableViewCell: UITableViewCell {

    // MARK: - private UI elements
    @IBOutlet weak var thumbnailTVShow: UIImageView!
    @IBOutlet weak var titleTVShow: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension ShowsTableViewCell {
    func configure(with item: Show) {
        titleTVShow.text = item.title
        
        let url = URL(string: "https://api.infinum.academy" + item.imageUrl)
        let placeholderImage = UIImage(named: "Image-5")
        thumbnailTVShow.kf.setImage(with: url, placeholder: placeholderImage)
    }
}

//extension ShowsTableViewCell {
//    func
//}

