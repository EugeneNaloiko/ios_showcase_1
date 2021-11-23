//
//  BaseSegmentedControl.swift
//
//  Created by Eugene Naloiko.
//

import Foundation
import UIKit

class BaseSegmentedControl: UISegmentedControl {
    
    struct SegmentedStyleModel {
        let fontNormal: UIFont
        let fontSelected: UIFont
        let colorNormal: UIColor
        let colorSelected: UIColor
        let tintColor: UIColor
    }
    
    enum StyleSEgmentControl {
        case defaultStyle
        
        var settings: SegmentedStyleModel {
            switch self {
            case .defaultStyle:
                return SegmentedStyleModel(fontNormal: UIFont.sfProFont(.semibold, size: 16),
                                           fontSelected: UIFont.sfProFont(.semibold, size: 16),
                                           colorNormal: UIColor.tfLightGray,
                                           colorSelected: UIColor.tfOrangish,
                                           tintColor: UIColor.tfWhite)
            }
        }
    }
    
    init(style: StyleSEgmentControl) {
        super.init(frame: .zero)
        self.setStyle(style: style)
        self.prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle(style: StyleSEgmentControl) {
        let normalTitleTextAttributes = [NSAttributedString.Key.foregroundColor: style.settings.colorNormal,
                                         NSAttributedString.Key.font: style.settings.fontNormal]
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: style.settings.colorSelected,
                                           NSAttributedString.Key.font: style.settings.fontSelected]
        self.setTitleTextAttributes(normalTitleTextAttributes, for: .normal)
        self.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = style.settings.tintColor
        } else {
            self.tintColor = style.settings.tintColor
        }
        
    }
    
    private func prepareUI() {
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
    }
    
    func setNameForSegmentItems(names: [String]) {
        self.removeAllSegments()
        for (index, name) in names.enumerated() {
            self.insertSegment(withTitle: name, at: index, animated: true)
        }
    }
}

