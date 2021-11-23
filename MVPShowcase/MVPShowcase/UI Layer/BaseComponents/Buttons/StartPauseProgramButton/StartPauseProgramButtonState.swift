//
//  StartPauseProgramButtonState.swift
//
//  Created by Eugene Naloiko
//

import UIKit

enum StartPauseProgramButtonState {
    case start
    case pause
    case unPause
    case purchase
    
    var settings: StartPauseProgramButtonStylesModel {
        switch self {
        case .start:
            
            return StartPauseProgramButtonStylesModel(
                backgroundColorEnabledState: UIColor.tfOrangish,
                backgroundColorDisabledState: UIColor.tfOrangish,
                
                font: .sfProFont(.regular, size: 16),
                titleText: L.string("START_PROGRAM"),
                
                fontColorEnabledState: UIColor.tfWhite,
                fontColorDisabledState: UIColor.tfWhite,
                
                imageNameEnabledState: "img_start_program_button",
                imageNameDisabledState: "img_start_program_button",
                
                borderColorEnabledState: nil,
                borderColorDisabledState: nil,
                
                borderWidthEnabledState: 0,
                borderWidthDisabledState: 0)
            
        case .pause:
            return StartPauseProgramButtonStylesModel(
                backgroundColorEnabledState: UIColor.tfOrangish,
                backgroundColorDisabledState: UIColor.tfOrangish,
                
                font: .sfProFont(.regular, size: 16),
                titleText: L.string("PAUSE_PROGRAM"),
                
                fontColorEnabledState: UIColor.tfWhite,
                fontColorDisabledState: UIColor.tfWhite,
                
                imageNameEnabledState: "img_pause_program_button",
                imageNameDisabledState: "img_pause_program_button",
                
                borderColorEnabledState: nil,
                borderColorDisabledState: nil,
                
                borderWidthEnabledState: 0,
                borderWidthDisabledState: 0)
            
        case .unPause:
            return StartPauseProgramButtonStylesModel(
                backgroundColorEnabledState: UIColor.tfOrangish,
                backgroundColorDisabledState: UIColor.tfOrangish,
                
                font: .sfProFont(.regular, size: 16),
                titleText: L.string("RESUME_PROGRAM"),
                
                fontColorEnabledState: UIColor.tfWhite,
                fontColorDisabledState: UIColor.tfWhite,
                
                imageNameEnabledState: "img_start_program_button",
                imageNameDisabledState: "img_start_program_button",
                
                borderColorEnabledState: nil,
                borderColorDisabledState: nil,
                
                borderWidthEnabledState: 0,
                borderWidthDisabledState: 0)
            
        case .purchase:
            
            return StartPauseProgramButtonStylesModel(
                backgroundColorEnabledState: UIColor.tfOrangish,
                backgroundColorDisabledState: UIColor.tfOrangish,
                
                font: .sfProFont(.regular, size: 16),
                titleText: L.string("PURCHASE_PROGRAM"),
                
                fontColorEnabledState: UIColor.tfWhite,
                fontColorDisabledState: UIColor.tfWhite,
                
                imageNameEnabledState: "img_purchase_icon",
                imageNameDisabledState: "img_purchase_icon",
                
                borderColorEnabledState: nil,
                borderColorDisabledState: nil,
                
                borderWidthEnabledState: 0,
                borderWidthDisabledState: 0)
        }
    }
    
}
