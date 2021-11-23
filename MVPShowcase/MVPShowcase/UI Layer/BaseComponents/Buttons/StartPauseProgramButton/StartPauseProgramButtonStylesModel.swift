//
//  StartPauseProgramButtonStylesModel.swift
//
//  Created by Eugene Naloiko
//

import UIKit

class StartPauseProgramButtonStylesModel {
    
    var backgroundColorEnableState: UIColor
    var backgroundColorDisabledState: UIColor
    
    var font: UIFont
    var titleText: String
    
    var fontColorEnabledState: UIColor
    var fontColorDisabledState: UIColor
    
    var imageNameEnabledState: String?
    var imageNameDisabledState: String?
    
    var borderColorEnabledState: CGColor?
    var borderColorDisabledState: CGColor?
    
    var borderWidthEnabledState: CGFloat?
    var borderWidthDisabledState: CGFloat?
    
    init(backgroundColorEnabledState: UIColor,
         backgroundColorDisabledState: UIColor,
         
         font: UIFont,
         titleText: String,
         
         fontColorEnabledState: UIColor,
         fontColorDisabledState: UIColor,
         
         imageNameEnabledState: String?,
         imageNameDisabledState: String?,
         
         borderColorEnabledState: CGColor?,
         borderColorDisabledState: CGColor?,
         
         borderWidthEnabledState: CGFloat?,
         borderWidthDisabledState: CGFloat?) {
        
        self.backgroundColorEnableState = backgroundColorEnabledState
        self.backgroundColorDisabledState = backgroundColorDisabledState
        
        self.font = font
        self.titleText = titleText
        
        self.fontColorEnabledState = fontColorEnabledState
        self.fontColorDisabledState = fontColorDisabledState
        
        self.imageNameEnabledState = imageNameEnabledState
        self.imageNameDisabledState = imageNameDisabledState
        
        self.borderColorEnabledState = borderColorEnabledState
        self.borderColorDisabledState = borderColorDisabledState
        
        self.borderWidthEnabledState = borderWidthEnabledState
        self.borderWidthDisabledState = borderWidthDisabledState
    }
}
