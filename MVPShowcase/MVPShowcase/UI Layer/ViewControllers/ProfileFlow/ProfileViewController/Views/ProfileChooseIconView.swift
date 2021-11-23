//
//  ProfileChooseIconView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit
import SDWebImage

final class ProfileChooseIconView: UIView {
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let imageCamera: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.backgroundColor = UIColor.clear
        imgView.image = UIImage(named: "img_camera")
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let btnGoToProfile: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    private let lblFullNameFirstLetters: UILabel = {
        let lbl = UILabel()
        lbl.layer.masksToBounds = true
        lbl.backgroundColor = UIColor.tfLightGreyBlue
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfWhite
        lbl.font = UIFont.sfProFont(.bold, size: 32)
        return lbl
    }()
    
    private let activityIndicator = BaseActivityIndicator(backgroundColor: UIColor.tfBeige, size: .small)
    
    var btnGoToProfileTappedClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblFullNameFirstLetters.layer.cornerRadius = self.lblFullNameFirstLetters.bounds.height / 2
        self.imageView.layer.cornerRadius = self.imageView.bounds.height / 2
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.tfWhite
        self.btnGoToProfile.addTarget(self, action: #selector(btnGoToProfileTapped(_:)), for: UIControl.Event.touchUpInside)
        
        addingViews()
        setupConstraints()
    }
    
    @objc private func btnGoToProfileTapped(_ sender: UIButton) {
        self.btnGoToProfileTappedClosure?()
    }
    
    
    private func addingViews() {
        self.addSubview(self.lblFullNameFirstLetters)
        self.addSubview(self.imageView)
        self.addSubview(self.imageCamera)
        self.addSubview(self.btnGoToProfile)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageCamera.translatesAutoresizingMaskIntoConstraints = false
        
        btnGoToProfile.pinToView(view: self)
        lblFullNameFirstLetters.pinToView(view: self.imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 87),
            imageView.widthAnchor.constraint(equalToConstant: 87),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            imageCamera.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor),
            imageCamera.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            imageCamera.heightAnchor.constraint(equalToConstant: 24),
            imageCamera.widthAnchor.constraint(equalToConstant: 24)
        ])
        
    }
    
    func setFirstNameAndLastName(firstName: String, lastName: String) {
        self.lblFullNameFirstLetters.text = "\(firstName.first?.uppercased() ?? "")\(lastName.first?.uppercased() ?? "")"
    }
    
    func setImage(url: URL) {
        self.imageView.sd_setImage(with: url) { image, _, _, _ in
            if image == nil {
                self.lblFullNameFirstLetters.isHidden = false
            } else {
                self.lblFullNameFirstLetters.isHidden = true
            }
        }
    }
    
    func setImage(image: UIImage?) {
        self.imageView.image = image
        if image == nil {
            self.lblFullNameFirstLetters.isHidden = false
        } else {
            self.lblFullNameFirstLetters.isHidden = true
        }
    }
    
    func setCameraHidden() {
        self.imageCamera.isHidden = true
    }
        
}
