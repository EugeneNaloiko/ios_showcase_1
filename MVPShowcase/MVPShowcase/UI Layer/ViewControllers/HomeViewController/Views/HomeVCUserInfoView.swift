//
//  HomeVCUserInfoView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class HomeVCUserInfoView: UIView {
 
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let lblFullNameFirstLetters: UILabel = {
        let lbl = UILabel()
        lbl.layer.masksToBounds = true
        lbl.backgroundColor = UIColor.tfLightGreyBlue
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfWhite
        lbl.font = UIFont.sfProFont(.bold, size: 14)
        return lbl
    }()
    
    private var lblHelloUsername: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.bold, size: 22)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let btnGoToProfile: UIButton = {
        let btn = UIButton()
        return btn
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
        self.imageView.layer.cornerRadius = self.imageView.bounds.height / 2
        self.lblFullNameFirstLetters.layer.cornerRadius = self.lblFullNameFirstLetters.bounds.height / 2
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
        self.addSubview(self.lblHelloUsername)
        self.addSubview(self.btnGoToProfile)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lblHelloUsername.translatesAutoresizingMaskIntoConstraints = false
        
        lblFullNameFirstLetters.pinToView(view: self.imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 32),
            
            lblHelloUsername.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            lblHelloUsername.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 16),
            lblHelloUsername.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            lblHelloUsername.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            lblHelloUsername.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
        
        btnGoToProfile.pinToView(view: self)
    }
    
    func startIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.activityIndicator.start(onView: sSelf.imageView)
        }
    }
    
    func stopIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stop()
        }
    }
    
    func setImage(image: UIImage) {
        self.lblFullNameFirstLetters.isHidden = true
        self.imageView.image = image
    }
    
    func setFirstNameAndLastName(firstName: String, lastName: String) {
        self.lblFullNameFirstLetters.text = "\(firstName.first?.uppercased() ?? "")\(lastName.first?.uppercased() ?? "")"
    }
    
    func updateUserFirstName(userFirstName: String) {
        self.lblHelloUsername.text = "\(L.string("WELCOME_BACK")), \(userFirstName)"
        
////        MARK: set image
//        if let urlString = userProfileDataModel?.profileImageId {
//            self.activityIndicator.start(onView: self.imageView)
            
//            self.imageView.loadImageUsingCache(fromURL: url, completion: { image in
//                DispatchQueue.main.async { [weak self] in
//                    guard let sSelf = self else { return }
//                    sSelf.imageView.image = image
//                    sSelf.activityIndicator.stop()
//                }
//            })
//        } else {
//            self.imageView.image = UIImage(named: "img_app_icon")
//        }
    }
    
}
