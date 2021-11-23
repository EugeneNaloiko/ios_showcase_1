//
//  UIFont + Extensions.swift
//
//  Created by Eugene Naloiko
//

import UIKit

enum SFProFont: String {
    case regular = "SFProText-Regular"
    case medium = "SFProText-Medium"
    case semibold = "SFProText-Semibold"
    case bold = "SFProText-Bold"
    case heavy = "SFProText-Heavy"
}

enum SFProDisplayFont: String {
    case regular = "SFProDisplay-Regular"
    case medium = "SFProDisplay-Medium"
    case semibold = "SFProDisplay-Semibold"
    case bold = "SFProDisplay-Bold"
}

extension UIFont {
    
    class func sfProFont(_ type: SFProFont, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
    
    class func sfProDisplayFont(_ type: SFProDisplayFont, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}
