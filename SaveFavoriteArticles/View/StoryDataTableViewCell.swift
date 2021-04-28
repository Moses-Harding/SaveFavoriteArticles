//
//  StoryDataTableViewCell.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/10/21.
//

import UIKit

class StoryDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topView: UIStackView!
    

    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var abstractView: UIView!
    @IBOutlet weak var bottomView: UIStackView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBOutlet weak var titleUnderlineView: UIView!
    @IBOutlet weak var imageUnderlineView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var subsectionTitle: UILabel!
    
    
    @IBOutlet weak var tagView: UIStackView!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var subsectionView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 0
        
        sectionView.layer.cornerRadius = 8
        subsectionView.layer.cornerRadius = 8

        sectionView.backgroundColor = tagColor
        subsectionView.backgroundColor = tagColor
        
        sectionView.isHidden = true
        subsectionView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectionStyle = .none
        // Configure the view for the selected state
        
        if selected {
            titleUnderlineView.backgroundColor = UIColor(red: 1, green: 0.749, blue: 0.5294, alpha: 1.0)
            imageUnderlineView.backgroundColor = UIColor(red: 1, green: 0.749, blue: 0.5294, alpha: 1.0)
        } else {
            titleUnderlineView.backgroundColor = .clear
            imageUnderlineView.backgroundColor = .clear
        }
    }
    
    func setFavorite(_ isFavorite: Bool) {
        
        favoriteImageView.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    func setTags(section: String, subsection: String) {
        
        if section != "" {
            sectionTitle.text = " " + section + " "
            sectionView.isHidden = false
        }
        
        if subsection != "" {
            subsectionTitle.text = " " + subsection + " "
            subsectionView.isHidden = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        storyImageView.image = nil
        sectionView.isHidden = true
        subsectionView.isHidden = true
    }
    
    @IBAction func imageWasTapped(_ sender: UITapGestureRecognizer) {
        print("image was tapped")
    }
}
