//
//  UITableView + Extensions.swift
//
//  Created by Eugene Naloiko
//

import UIKit

extension UITableView {
    
    func scrollToFirstRow(animated: Bool) {
       let indexPath = IndexPath(row: 0, section: 0)
       self.scrollToRow(at: indexPath, at: .top, animated: animated)
     }
    
}
