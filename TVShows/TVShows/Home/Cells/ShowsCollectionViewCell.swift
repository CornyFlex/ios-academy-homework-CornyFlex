//
//  ShowsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 19/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit
import Kingfisher

class ShowsCollectionViewCell: UICollectionViewCell {

    // MARK: - private UI elements
    @IBOutlet weak var thumbnailTVShow: UIImageView!
    @IBOutlet weak var titleTVShow: UILabel!
}

extension ShowsCollectionViewCell {
    func configure(with item: Show, layout: Bool) {
        
        if layout == false {
        titleTVShow.text = item.title
        titleTVShow.isHidden = false
        } else {
            titleTVShow.isHidden = true
        }
        
        let url = URL(string: "https://api.infinum.academy" + item.imageUrl)
        let placeholderImage = UIImage(named: "Image-5")
        thumbnailTVShow.kf.setImage(with: url, placeholder: placeholderImage)
        addShadowToImage()
    }
}

extension ShowsCollectionViewCell {
    
    func addShadowToImage() {
        thumbnailTVShow.layer.shadowColor = UIColor.black.cgColor
        thumbnailTVShow.layer.shadowOffset = CGSize(width: 5, height: 5)
        thumbnailTVShow.layer.shadowRadius = 5
        thumbnailTVShow.layer.shadowOpacity = 1.0
    }
}

