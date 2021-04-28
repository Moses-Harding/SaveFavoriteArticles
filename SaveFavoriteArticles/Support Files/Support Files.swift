//
//  Support Files.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/10/21.
//

import Foundation
import UIKit

extension UILabel {
    func approximateAdjustedFontSize() -> CGFloat {
        
        var currentFont: UIFont = self.font
        let originalFontSize = currentFont.pointSize
        var currentSize: CGSize = (self.text! as NSString).size(withAttributes: [NSAttributedString.Key.font: currentFont])

        while currentSize.width > self.frame.size.width && currentFont.pointSize > (originalFontSize * self.minimumScaleFactor) {
            currentFont = currentFont.withSize(currentFont.pointSize - 1.0)
            currentSize = (self.text! as NSString).size(withAttributes: [NSAttributedString.Key.font: currentFont])
        }
        
        return currentFont.pointSize
    }
}
