//
//  BaseSeparatorView.swift
//
//  Created by Eugene Naloiko
//

import UIKit

class BaseSeparatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.tfWhiteDark
    }
    
    private func addingViews() {
        
    }
    
    private func setupConstraints() {
        
    }
    
}
