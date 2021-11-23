//
//  BaseBackgroundViewWithShadow.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

class BaseShadowView: UIView {
    
    private let shadowType: ShadowType
    
    init(shadowType: ShadowType) {
        self.shadowType = shadowType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.layer.shadowPath == nil {
            self.setupShadow(type: self.shadowType)
        }
    }

}
