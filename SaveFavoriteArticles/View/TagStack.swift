//
//  TagStack.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/11/21.
//

import UIKit

class TagStack: UIStackView {
    
    var delegate: StoryControl?

    
    func addTag(_ tag: String) {
        
        guard !tag.isEmpty else { return }
        
            let view = Tag(tag)
            self.addArrangedSubview(view)
    }
    
    func removeTags() {
        
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}

class Tag: UIView {
    
    var label = UILabel()
    var filter: String!
    
    init(_ tag: String) {
        super.init(frame: CGRect.zero)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.filter = tag
        label.text = " \(tag) "
        label.textColor = .white
        
        self.backgroundColor = tagColor
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let parent = self.superview as? TagStack else { return }
        parent.delegate?.setFilter(from: filter)
    }
}
