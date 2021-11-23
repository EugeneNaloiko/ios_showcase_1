//
//  BaseButtonStyle.swift
//
//  Created by Eugene Naloiko
//

import UIKit

enum BaseButtonStyle {
    case orange
    case lightOrange
    
    var settings: BaseButtonStylesModel {
        switch self {
        case .orange:
            return BaseButtonStylesModel(backgroundColorEnableState: UIColor.tfOrangish,
                                         backgroundColorNotEnableState: UIColor.tfOrangish50,
                                         
                                         font: .sfProFont(.regular, size: 16),
                                         
                                         fontColorEnableState: UIColor.tfWhite,
                                         fontColorNotEnableState: UIColor.tfWhiteFive,
                                         
                                         borderColorEnableState: nil,
                                         borderColorNotEnableState: nil,
                                         
                                         borderWidthEnableState: 0,
                                         borderWidthDisabledState: 0)
            
        case .lightOrange:
            return BaseButtonStylesModel(backgroundColorEnableState: UIColor.tfOrangish10,
                                         backgroundColorNotEnableState: UIColor.tfOrangish10,
                                         
                                         font: .sfProFont(.semibold, size: 18),
                                         
                                         fontColorEnableState: UIColor.tfOrangish,
                                         fontColorNotEnableState: UIColor.tfOrangish,
                                         
                                         borderColorEnableState: nil,
                                         borderColorNotEnableState: nil,
                                         
                                         borderWidthEnableState: 0,
                                         borderWidthDisabledState: 0)
        }
    }
    
}
