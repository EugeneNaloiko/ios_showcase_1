//
//  DeviceOfflineView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class DeviceOfflineView: UIView {
    
    private let contentView = DeviceOfflineContentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.tfWhite
    }
    
    private func addingViews() {
        self.addSubview(contentView)
    }
    
    private func setupConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            self.contentView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 40)
        ])
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.contentView.setData(titleText: titleText, descriptionText: descriptionText)
    }
    
}
