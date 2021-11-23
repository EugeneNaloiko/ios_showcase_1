//
//  UIColor + Extensions.swift
//
//  Created by Eugene Naloiko
//

import UIKit

extension UIColor {
    
    // MARK: Need set correct name
    //#F4F5F7
    @nonobjc class var tfWhiteDark: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }
    
    static let tfBlack = UIColor(hexString: "#000000")
    static let tfBlack60 = UIColor(hexString: "#000000").withAlphaComponent(0.6)
    static let tfBlackSix = UIColor(hexString: "#1A1A1A")
    
    //#CCCCCB
    @nonobjc class var tfBeige: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
    }
    
    //#FFFFFF
    @nonobjc class var tfWhite: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    //#F6F6F6
    @nonobjc class var tfWhiteThree: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
    }
    
    //#F4F4F4
    @nonobjc class var tfWhiteFour: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
        
    static let tfWhiteFive = UIColor(hexString: "#FAFAFA")
    static let tfSlate = UIColor(hexString: "#505F79")
    static let tfCharcoalGrey30 = UIColor(hexString: "#3C3C43").withAlphaComponent(0.3)
    static let tfLightGreyBlue = UIColor(hexString: "#9FA5C0")
    static let tfLightGreyBlue20 = UIColor(hexString: "#9FA5C0").withAlphaComponent(0.2)
    static let tfGreyishBrownFour = UIColor(hexString: "#5A5B3A")
    static let tfGreyishBrownFour40 = UIColor(hexString: "#5A5B3A").withAlphaComponent(0.4)
    static let tfLessDarker = UIColor(hexString: "#403E54")
    static let tfVeryLightPink = UIColor(hexString: "#EFEFEF")
    static let tfLightGreyBlueTwo = UIColor(hexString: "#B3BAC5")
    static let tfWhiteSix = UIColor(hexString: "#F8F8F8")
    static let tfNavy = UIColor(hexString: "#031B4A")
    static let tfGrayFive = UIColor(hexString: "#E5E5E5")
    static let tfGraySuperDark = UIColor(hexString: "#354A52")
    static let tfGreen = UIColor(hexString: "#19A765")
    static let tfBlue = UIColor(hexString: "#4986E7")
    static let tfGraySix = UIColor(hexString: "#F2F2F2")
    static let tfGrayPink = UIColor(hexString: "#E8E0E0")
    
    //#F16C47
    @nonobjc class var tfOrangish: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 108.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    }
    
    //#F16C47, 50%
    @nonobjc class var tfOrangish50: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 108.0 / 255.0, blue: 71.0 / 255.0, alpha: 0.5)
    }
    
    //#F16C47, 10%
    @nonobjc class var tfOrangish10: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 108.0 / 255.0, blue: 71.0 / 255.0, alpha: 0.1)
    }
    
    //#FCFCFD
    @nonobjc class var tfPaleGrey: UIColor {
        return UIColor(red: 252.0 / 255.0, green: 252.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0)
    }
    
    //#B8B8B8
    @nonobjc class var tfGray: UIColor {
        return UIColor(red: 184.0 / 255.0, green: 184.0 / 255.0, blue: 184.0 / 255.0, alpha: 1.0)
    }
    
    //#BDBDBD
    @nonobjc class var tfLightGray: UIColor {
        return UIColor(red: 189.0 / 255.0, green: 189.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
    }
    
    //#E8E8E8
    @nonobjc class var tfVeryLightGray: UIColor {
        return UIColor(red: 232.0 / 255.0, green: 232.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    }
    
    
    static let tfCoral = UIColor(hexString: "#FF5247")
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}
