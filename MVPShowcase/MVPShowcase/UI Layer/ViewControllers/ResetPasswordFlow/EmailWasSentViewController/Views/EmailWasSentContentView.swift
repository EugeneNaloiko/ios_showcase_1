//
//  EmailWasSentContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class EmailWasSentContentView: UIView {
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "img_email_sent")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 30)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let btnOpenEmailApp: BaseButton = {
        let btn = BaseButton(style: .lightOrange)
        btn.setTitle(L.string("OPEN_EMAIL_APP"), for: UIControl.State.normal)
        return btn
    }()
    
    var btnEmailTappedClosure: (() -> Void)?
    
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
        self.subscribeClosures()
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.tfWhite
    }
    
    private func addingViews() {
        self.addSubview(imgView)
        self.addSubview(lblTitle)
        self.addSubview(lblDescription)
        self.addSubview(btnOpenEmailApp)
    }
    
    private func setupConstraints() {
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        btnOpenEmailApp.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imgView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imgView.widthAnchor.constraint(equalToConstant: 260),
            
            lblTitle.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 30),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 20),
            lblDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            lblDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            btnOpenEmailApp.topAnchor.constraint(equalTo: self.lblDescription.bottomAnchor, constant: 35),
            btnOpenEmailApp.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            btnOpenEmailApp.widthAnchor.constraint(equalToConstant: 210),
            btnOpenEmailApp.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
        ])
    }
    
    private func subscribeClosures() {
        self.btnOpenEmailApp.didTapClosure = { [weak self] in
            self?.btnEmailTappedClosure?()
        }
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
    }
    
}
