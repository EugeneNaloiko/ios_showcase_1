//
//  UILabel + Extensions.swift
//
//  Created by Eugene Naloiko
//

import UIKit

extension UILabel {
    
    func getHeightByTextAndWidth(text: String?, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
}
