//
//  UINavigationBar + Extensions.swift
//
//  Created by Eugene Naloiko
//

import UIKit

extension UINavigationBar {
    
    func setNavigationBarTransparent() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    func unsetTransparentNavigationBar() {
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = nil
        self.isTranslucent = false
    }
}
