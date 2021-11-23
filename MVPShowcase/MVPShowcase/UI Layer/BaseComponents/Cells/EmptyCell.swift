//
//  EmptyCell.swift
//
//  Created by Eugene Naloiko
//

import UIKit

final class EmptyCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
