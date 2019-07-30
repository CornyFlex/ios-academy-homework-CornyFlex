//
//  CommentTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 29/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentUserImage: UIImageView!
    @IBOutlet weak var commentUserNameLabel: UILabel!
    @IBOutlet weak var commentUserMessageLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CommentTableViewCell {
    func configureComment(with item: Comment) {
        commentUserNameLabel.text = item.userEmail
        commentUserMessageLabel.text = item.text
        commentUserImage.image = randomImage(for: Int.random(in: 0...2))
    }
    
    func randomImage(for number: Int) -> UIImage? {
        switch number{
        case 0:
            return UIImage(named: "placeholder2")
        case 1:
            return UIImage(named: "placeholder3")
        case 2:
            return UIImage(named: "placeholderEpisodeDetails")
        default:
            return nil
        }
    }
}
