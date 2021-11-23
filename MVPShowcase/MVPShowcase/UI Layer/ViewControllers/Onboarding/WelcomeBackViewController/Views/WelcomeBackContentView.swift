//
//  WelcomeBackContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WelcomeBackContentView: UIView {
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.setContentHuggingPriority(.defaultLow, for: .vertical)
        img.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return img
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 30)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        lbl.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.setContentHuggingPriority(.defaultHigh, for: .vertical)
        lbl.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return lbl
    }()
    
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
        self.addSubview(imgView)
        self.addSubview(lblTitle)
        self.addSubview(lblDescription)
    }
    
    private func setupConstraints() {
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.imgView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            self.imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imgView.heightAnchor.constraint(lessThanOrEqualToConstant: 335),
            
            lblTitle.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 30),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 20),
            lblDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lblDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
    
    func setData(imageName: String, titleText: String, descriptionText: String) {
        self.imgView.image = UIImage(named: imageName)
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
    }
    
}
