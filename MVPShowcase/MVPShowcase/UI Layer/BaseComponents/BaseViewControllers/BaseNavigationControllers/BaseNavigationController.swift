//
//  BaseNavigationController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        self.removeBottomLine()
    }
}

extension BaseNavigationController {
    
    private func prepareUI() {
        self.navigationBar.isTranslucent = false
    }
    
    private func removeBottomLine() {
        self.navigationBar.shadowImage = UIImage()
    }
    
}
