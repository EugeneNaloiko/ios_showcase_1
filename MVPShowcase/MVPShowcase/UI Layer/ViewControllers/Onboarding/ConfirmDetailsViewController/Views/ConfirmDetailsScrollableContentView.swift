//
//  ConfirmDetailsScrollableContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

class ConfirmDetailsScrollableContentView: UIView {
    
    private let headerView = OnboardingHeaderViewWithLogo()
    private let contentView = ConfirmDetailsContentView()
    
    var headerViewTopAnchor: NSLayoutConstraint?
    var contentViewBottomConstraint: NSLayoutConstraint?
    
    var btnEditTappedClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
//        self.backgroundColor = UIColor.tfWhiteFive
        addingViews()
        configureConstraints()
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 8
        subscribeClosures()
    }
    
    func addingViews() {
        self.addSubview(self.headerView)
        self.addSubview(self.contentView)
    }
    
    func configureConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
//        let window = UIApplication.shared.windows.first
//        let topPadding = window?.safeAreaInsets.top
//        let bottomPadding = window?.safeAreaInsets.bottom
        self.headerViewTopAnchor = self.headerView.topAnchor.constraint(equalTo: self.topAnchor, constant:  0)
        self.headerViewTopAnchor?.isActive = true
        
        self.contentViewBottomConstraint = self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        self.contentViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
//            self.headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -10),
//            self.headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: (topPadding ?? 0)),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.contentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 20),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
//            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -90)
        ])
        
    }
    
    func setHeaderData(titleText: String?, descriptionText: String?) {
        self.headerView.setData(titleText: titleText, descriptionText: descriptionText)
    }
    
    func setupCountryViewDetails(countryName: String) {
        self.contentView.setupCountryViewDetails(countryName: countryName)
    }
    
    func setupGenderViewDetails(detailsItems: [String]) {
        self.contentView.setupGenderViewDetails(detailsItems: detailsItems)
    }
    
    func setupDateOfBirthViewDetails(detailsItems: [String]) {
        self.contentView.setupDateOfBirthViewDetails(detailsItems: detailsItems)
    }
    
    func setupFitnessLevelViewDetails(detailsItems: [String]) {
        self.contentView.setupFitnessLevelViewDetails(detailsItems: detailsItems)
    }
    
    func setupEquipmentsViewDetails(detailsItems: [String]) {
        self.contentView.setupEquipmentsViewDetails(detailsItems: detailsItems)
    }
    
    private func subscribeClosures() {
        self.contentView.btnEditTappedClosure = { [weak self] in
            self?.btnEditTappedClosure?()
        }
    }
    
}

