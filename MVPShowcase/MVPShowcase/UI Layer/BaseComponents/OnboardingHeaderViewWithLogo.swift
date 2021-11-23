//
//  OnboardingHeaderViewWithLogo.swift
//
//  Created by Eugene Naloiko
//

import UIKit

final class OnboardingHeaderViewWithLogo: UIView {
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "img_logo_orange")
        return imgView
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 30)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.isHidden = true
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.isHidden = true
        return lbl
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        sv.alignment = .center
        return sv
    }()
    
    private var logoImageViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.tfWhite
        
        self.addingViews()
        self.setupConstraints()
    }
    
    private func addingViews() {
        self.addSubview(self.imageView)
    
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblDescription)
        
        self.addSubview(stackView)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 44)
        logoImageViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 44),
            
            stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
    }
    
    func setData(titleText: String?, descriptionText: String?) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
        
        if let text = self.lblTitle.text, text != "" {
            self.lblTitle.isHidden = false
        }
        
        if let text = self.lblDescription.text, text != "" {
            self.lblDescription.isHidden = false
        }
        
    }
    
    func setLogoHidden() {
        self.imageView.isHidden = true
        logoImageViewHeightConstraint?.constant = 0
    }
    
}
