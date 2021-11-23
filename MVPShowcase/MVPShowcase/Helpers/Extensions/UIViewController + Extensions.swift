//
//  UIViewController + Extensions.swift
//
//  Created by Eugene Naloiko
//

import UIKit

extension UIViewController {
    
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
    
    public func motionDismissViewController() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            if let v = sSelf.navigationController, self != v.viewControllers.first {
                v.popViewController(animated: true)
            } else {
                sSelf.dismiss(animated: true)
            }
        }
    }
    
}
