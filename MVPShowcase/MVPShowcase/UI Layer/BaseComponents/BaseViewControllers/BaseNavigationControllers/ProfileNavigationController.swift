//
//  ProfileNavigationController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        self.setupBottomLine()
    }
    
    private func prepareUI() {
        self.navigationBar.isTranslucent = false
    }
    
    func setupBottomLine() {
        self.navigationBar.shadowImage = UIImage(color: UIColor.tfWhiteDark)
    }
    
}
