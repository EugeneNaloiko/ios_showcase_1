//
//  HomeScreenHeaderWithArrow.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

class HomeScreenHeaderWithArrow: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.baselineAdjustment = .alignCenters
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.bold, size: 16)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private var btnSeeAll = SeeAllWithArrowButton()
    
    var btnSeeAllTappedClosure: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        self.contentView.backgroundColor = .tfWhite
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.lblTitle)
        self.contentView.addSubview(self.btnSeeAll)
    }
    
    private func setupConstraints() {
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.btnSeeAll.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.lblTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
//            self.lblTitle.trailingAnchor.constraint(equalTo: self.btnSeeAll.leadingAnchor, constant: -8),
            self.lblTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -14),
            self.lblTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            self.btnSeeAll.centerYAnchor.constraint(equalTo: self.lblTitle.centerYAnchor),
            self.btnSeeAll.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
//            self.btnSeeAll.heightAnchor.constraint(equalToConstant: 40),
//            self.btnSeeAll.widthAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    
    private func subscribeClosures() {
        self.btnSeeAll.btnTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.btnSeeAllTappedClosure?()
        }
    }
    
    func setData(titleText: String) {
        self.lblTitle.text = titleText
    }
    
}
