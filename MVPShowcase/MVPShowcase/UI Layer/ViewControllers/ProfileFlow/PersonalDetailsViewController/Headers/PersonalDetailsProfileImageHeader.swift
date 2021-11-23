//
//  PersonalDetailsProfileImageHeader.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class PersonalDetailsProfileImageHeader: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
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
        self.contentView.addSubview(self.profileChooseIconView)
    }
    
    private func setupConstraints() {
        profileChooseIconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.profileChooseIconView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 32),
            self.profileChooseIconView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.profileChooseIconView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -40)
        ])
    }
    
    func setFirstNameAndLastName(firstName: String, lastName: String) {
        self.profileChooseIconView.setFirstNameAndLastName(firstName: firstName, lastName: lastName)
    }
        
    func setImage(url: URL) {
        self.profileChooseIconView.setImage(url: url)
    }
    
    func setImage(image: UIImage?) {
        self.profileChooseIconView.setImage(image: image)
    }
}
