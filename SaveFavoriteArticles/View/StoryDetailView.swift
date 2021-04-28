//
//  StoryDetailView.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/16/21.
//

import UIKit

class StoryDetailView: UIView, UIGestureRecognizerDelegate {
    
    var containerBody = UIStackView()
    var titleLabel = UILabel()
    var byLineLabel = UILabel()
    var kickerLabel = UILabel()
    var imageView = UIImageView()
    var abstractLabel = UILabel()
    var dateLabel = UILabel()
    
    var centerConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    
    var startTouch: CGPoint?
    var endTouch: CGPoint?
    
    var url: String?
    
    init(story: Story, parent: UIView) {
        super.init(frame: CGRect.zero)
        
        constrain(to: parent)
        
        formatViews()
        
        titleLabel.text = story.article.title
        byLineLabel.text = story.article.byline
        kickerLabel.text = story.article.kicker
        abstractLabel.text = story.article.abstract
        dateLabel.text = story.article.published_date
        
        kickerLabel.isHidden = story.article.kicker.isEmpty ? true : false
        
        self.backgroundColor = UIColor.label
        self.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func formatViews() {
        
        self.addSubview(containerBody)
        containerBody.translatesAutoresizingMaskIntoConstraints = false
        
        //containerBody.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        //containerBody.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        containerBody.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        containerBody.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true
        containerBody.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerBody.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        
        containerBody.addArrangedSubview(titleLabel)
        containerBody.addArrangedSubview(byLineLabel)
        containerBody.addArrangedSubview(imageView)
        containerBody.addArrangedSubview(abstractLabel)
        containerBody.addArrangedSubview(dateLabel)
        
        containerBody.axis = .vertical
        containerBody.spacing = 10
        
        imageView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.4).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        formatLabel(label: titleLabel, fontName: "TimesNewRomanPS-BoldMT", size: 35)
        formatLabel(label: byLineLabel, fontName: "HelveticaNeue", size: 20)
        formatLabel(label: kickerLabel, size: 15)
        formatLabel(label: abstractLabel, size: 20)
        formatLabel(label: dateLabel, fontName: "HelveticaNeue", size: 12, alignment: .right, textColor: .gray)
    }
    
    func constrain(to parent: UIView) {
        
        parent.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.heightAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.heightAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        
        topConstraint = self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor)
        centerConstraint = self.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
        topConstraint.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.topConstraint.isActive = false
            self.centerConstraint.isActive = true
        }, completion: { bool in
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            })
        })
    }
    
    func formatLabel(label: UILabel, fontName: String = "TimesNewRomanPSMT", size: CGFloat, alignment: NSTextAlignment = .left, textColor: UIColor = .systemBackground) {
        
        guard let font = UIFont(name: fontName, size: size) else {
            return
        }
        
        label.textColor = textColor
        label.numberOfLines = 0
        label.font = font
        label.textAlignment = alignment
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            if startTouch == nil {
                startTouch = touch.location(in: self)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            endTouch = touch.location(in: self)
            
//            if touch.location(in: titleLabel) {
//                if let url = URL(string: self.url ?? "www.nytimes.com") {
//                            UIApplication.shared.open(url)
//                        }
//            }
            
            guard let start = startTouch?.y, let end = endTouch?.y else { return }
            
            if start < end {
                
                centerConstraint.isActive = false
                topConstraint.isActive = true
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.layoutIfNeeded()
                }) { (true) in
                    
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}
