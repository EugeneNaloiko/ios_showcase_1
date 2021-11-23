//
//  BaseButtonStylesModel.swift
//
//  Created by Eugene Naloiko
//

import UIKit

class BaseButtonStylesModel {
    
    var backgroundColorEnableState: UIColor
    var backgroundColorNotEnableState: UIColor
    
    var font: UIFont
    
    var fontColorEnableState: UIColor
    var fontColorNotEnableState: UIColor
    
    var borderColorEnableState: CGColor?
    var borderColorNotEnableState: CGColor?
    
    var borderWidthEnableState: CGFloat?
    var borderWidthDisabledState: CGFloat?
    
    init(backgroundColorEnableState: UIColor,
         backgroundColorNotEnableState: UIColor,
         
         font: UIFont,
         
         fontColorEnableState: UIColor,
         fontColorNotEnableState: UIColor,
         
         borderColorEnableState: CGColor?,
         borderColorNotEnableState: CGColor?,
         
         borderWidthEnableState: CGFloat?,
         borderWidthDisabledState: CGFloat?) {
        
        self.backgroundColorEnableState = backgroundColorEnableState
        self.backgroundColorNotEnableState = backgroundColorNotEnableState
        
        self.font = font
        
        self.fontColorEnableState = fontColorEnableState
        self.fontColorNotEnableState = fontColorNotEnableState
        
        self.borderColorEnableState = borderColorEnableState
        self.borderColorNotEnableState = borderColorNotEnableState
        
        self.borderWidthEnableState = borderWidthEnableState
        self.borderWidthDisabledState = borderWidthDisabledState
    }
}
