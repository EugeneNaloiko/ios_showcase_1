//
//  ProfileDefaultHeaderView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ProfileDefaultHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfLightGreyBlueTwo
        lbl.font = UIFont.sfProFont(.regular, size: 12)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        self.contentView.backgroundColor = .tfWhite
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.lblTitle)
    }
    
    private func setupConstraints() {
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.lblTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            self.lblTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            self.lblTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func setTitle(titleText: String) {
        self.lblTitle.text = titleText
    }
    
}
