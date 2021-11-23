//
//  ProfileTopHeaderView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ProfileTopHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 30)
        return lbl
    }()
    
    private var lblUserName: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfNavy
        lbl.font = UIFont.sfProFont(.bold, size: 22)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private var lblEmail: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.regular, size: 12)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let profileChooseIconView = ProfileChooseIconView()
    
    var changeProfileImageTappedClosure: (() -> Void)?
    
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
        self.profileChooseIconView.btnGoToProfileTappedClosure = { [weak self] in
            self?.changeProfileImageTappedClosure?()
        }
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.lblTitle)
        self.contentView.addSubview(self.profileChooseIconView)
        self.contentView.addSubview(self.lblUserName)
        self.contentView.addSubview(self.lblEmail)
    }
    
    private func setupConstraints() {
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        profileChooseIconView.translatesAutoresizingMaskIntoConstraints = false
        lblUserName.translatesAutoresizingMaskIntoConstraints = false
        lblEmail.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.lblTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.lblTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            
            self.profileChooseIconView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 10),
            self.profileChooseIconView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            self.lblUserName.topAnchor.constraint(equalTo: self.profileChooseIconView.bottomAnchor, constant: 10),
            self.lblUserName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.lblUserName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            
            self.lblEmail.topAnchor.constraint(equalTo: self.lblUserName.bottomAnchor, constant: 0),
            self.lblEmail.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.lblEmail.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.lblEmail.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -24),
        ])
    }
    
    func setTitle(titleText: String) {
        self.lblTitle.text = titleText
    }
    
    func setUserName(fullName: String) {
        self.lblUserName.text = fullName
    }
    
    func setEmail(email: String) {
        self.lblEmail.text = email
    }
    
    func setImage(url: URL) {
        self.profileChooseIconView.setImage(url: url)
    }
    
    func setImage(image: UIImage?) {
        self.profileChooseIconView.setImage(image: image)
    }
    
    func hideCamera() {
        self.profileChooseIconView.setCameraHidden()
    }
    
    func setFirstNameAndLastName(firstName: String, lastName: String) {
        self.profileChooseIconView.setFirstNameAndLastName(firstName: firstName, lastName: lastName)
    }
}
