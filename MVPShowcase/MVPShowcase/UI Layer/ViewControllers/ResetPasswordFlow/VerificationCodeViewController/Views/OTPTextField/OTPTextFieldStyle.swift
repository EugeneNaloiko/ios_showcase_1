//
//  OTPTextFieldStyle.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

enum OTPTextFieldStyle {
    case orange
    case gray
    
    var settings: OTPTextFieldStyleModel {
        switch self {
        case .orange:
            return OTPTextFieldStyleModel(backgroundColor: UIColor.tfWhiteThree,
                                          font: UIFont.sfProFont(.semibold, size: 24),
                                          fontColor: .tfBlack,
                                          borderColor: UIColor.tfOrangish.cgColor,
                                          borderWidth: 1)
        case .gray:
            return OTPTextFieldStyleModel(backgroundColor: UIColor.tfWhiteThree,
                                          font: UIFont.sfProFont(.semibold, size: 24),
                                          fontColor: .tfBlack,
                                          borderColor: UIColor.tfVeryLightGray.cgColor,
                                          borderWidth: 1)
        }
    }
}

struct OTPTextFieldStyleModel {
    var backgroundColor: UIColor
    var font: UIFont
    var fontColor: UIColor
    var borderColor: CGColor?
    var borderWidth: CGFloat?
}

