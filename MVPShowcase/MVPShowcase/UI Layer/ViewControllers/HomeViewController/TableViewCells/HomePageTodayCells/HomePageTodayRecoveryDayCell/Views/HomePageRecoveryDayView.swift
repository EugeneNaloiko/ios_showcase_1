//
//  HomePageRecoveryDayView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class HomePageRecoveryDayView: UIView {
    
    private let backgroundImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "img_recovery_day")
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        return img
    }()
    
    private let filterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfBlack60
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "img_logo_orange")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfGraySix
        lbl.font = UIFont.sfProFont(.semibold, size: 20)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = L.string("ENJOY_YOUR_RECOVERY_DAY")
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfGrayPink
        lbl.font = UIFont.sfProFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = L.string("NO_MOVEMENTS_FOR_TODAY_RECOVER_AND_REENERGIZE_FOR_YOUR_NEXT_WORKOUT")
        return lbl
    }()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("VIEW_SCHEDULE"), for: UIControl.State.normal)
        return btn
    }()
    
    var btnNextTappedClosure: (() -> Void)?
    
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
        self.backgroundImageView.addSubview(self.filterView)
        self.addSubview(backgroundImageView)
        
        self.addSubview(lblTitle)
        self.addSubview(lblDescription)
        self.addSubview(logoImageView)
        self.addSubview(btnNext)
    }
    
    private func setupConstraints() {
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.filterView.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        self.filterView.pinToView(view: self.backgroundImageView)
        
        NSLayoutConstraint.activate([
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.backgroundImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.backgroundImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 343),
            self.backgroundImageView.heightAnchor.constraint(equalToConstant: 265),
            
            self.logoImageView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor, constant: 23),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor, constant: 0),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 27),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 27),
            
            lblTitle.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 28),
            lblTitle.leadingAnchor.constraint(equalTo: self.backgroundImageView.leadingAnchor, constant: 24),
            lblTitle.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor, constant: -24),
            
            lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 10),
            lblDescription.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            lblDescription.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            lblDescription.bottomAnchor.constraint(lessThanOrEqualTo: self.btnNext.topAnchor, constant: -30),
            
            self.btnNext.leadingAnchor.constraint(equalTo: self.backgroundImageView.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor, constant: -16),
            self.btnNext.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor, constant: -16)
        ])
    }
    
    private func subscribeClosures() {
        self.btnNext.didTapClosure = { [weak self] in
            self?.btnNextTappedClosure?()
        }
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
    }
    
}
