//
//  TopStoryCell.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/15/21.
//

import UIKit

class TopStoryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var storyImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        storyImageView.image = nil
    }

}
