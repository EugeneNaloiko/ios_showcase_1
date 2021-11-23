//
//  UIView + Extensions.swift
//
//  Created by Eugene Naloiko
//

import UIKit

enum ShadowType {
    case defaultType
    case defaultTypeBottomRightOffset
    case myPositionViewShadow
    
    var instance: ShadowModel {
        switch self {
        case .defaultType:
            return ShadowModel(shadowRadius: 12, opacity: 0.08, shadowColor: UIColor.tfBlack, offSet: CGSize(width: 0, height: 0))
        case .defaultTypeBottomRightOffset:
            return ShadowModel(shadowRadius: 8, opacity: 0.06, shadowColor: UIColor.tfBlack, offSet: CGSize(width: 10, height: 8))
        case .myPositionViewShadow:
            return ShadowModel(shadowRadius: 16, opacity: 0.7, shadowColor: UIColor.tfBlack, offSet: CGSize(width: 0, height: 0))
        }
    }
}

class ShadowModel {
    var shadowRadius: CGFloat
    var opacity: Float
    var shadowColor: UIColor
    var offSet: CGSize
    
    init(shadowRadius: CGFloat, opacity: Float, shadowColor: UIColor, offSet: CGSize) {
        self.shadowRadius = shadowRadius
        self.opacity = opacity
        self.shadowColor = shadowColor
        self.offSet = offSet
    }
}


extension UIView {
    
    func pinToView(view: UIView, safeAreaLayout: Bool = false) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if safeAreaLayout {
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
    func pinToView(view: UIView, withInsets insets: UIEdgeInsets) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive = true
    }
    
    // MARK: SHADOWS
    func setupShadow(type: ShadowType) {
        self.layer.shadowColor = type.instance.shadowColor.cgColor
        self.layer.shadowRadius = type.instance.shadowRadius
        self.layer.shadowOpacity = type.instance.opacity
        self.layer.shadowOffset = type.instance.offSet
        self.layer.shouldRasterize = true

        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: type.instance.shadowRadius, height: type.instance.shadowRadius)).cgPath
        self.layer.shadowPath = cgPath
    }
    
}
