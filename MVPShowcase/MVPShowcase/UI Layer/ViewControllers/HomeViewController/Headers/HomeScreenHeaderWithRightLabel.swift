//
//  HomeScreenHeaderWithRightLabel.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

class HomeScreenHeaderWithRightLabel: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.bold, size: 17)
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.textColor = UIColor.tfBeige
        lbl.font = UIFont.sfProDisplayFont(.semibold, size: 14)
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return lbl
    }()
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "img_cup_of_coffee")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private var btnSkip = UIButton()
    
    var btnSkipTappedClosure: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
        btnSkip.addTarget(self, action: #selector(btnSkipTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        self.contentView.backgroundColor = .tfWhite
    }
    
    @objc private func btnSkipTapped(_ sender: UIButton) {
        self.btnSkipTappedClosure?()
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.lblTitle)
        self.contentView.addSubview(self.lblDescription)
        self.contentView.addSubview(self.imgView)
        
        self.contentView.addSubview(self.btnSkip)
    }
    
    private func setupConstraints() {
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = false
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.btnSkip.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.lblTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.lblTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -14),
            
            self.imgView.centerYAnchor.constraint(equalTo: self.lblTitle.centerYAnchor, constant: -4),
            self.imgView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.imgView.widthAnchor.constraint(equalToConstant: 24),
            self.imgView.heightAnchor.constraint(equalToConstant: 24),
            
            self.lblDescription.centerYAnchor.constraint(equalTo: self.lblTitle.centerYAnchor),
            self.lblDescription.leadingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor, constant: 8),
            self.lblDescription.trailingAnchor.constraint(equalTo: self.imgView.leadingAnchor, constant: -4),
            
            self.btnSkip.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.btnSkip.leadingAnchor.constraint(equalTo: self.lblDescription.leadingAnchor),
            self.btnSkip.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.btnSkip.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
    }
    
    func setSkipButtonHidden() {
        self.imgView.isHidden = true
        self.lblDescription.isHidden = true
    }
    
    func setSkipButtonUnhidden() {
        self.imgView.isHidden = false
        self.lblDescription.isHidden = false
    }

    
}
