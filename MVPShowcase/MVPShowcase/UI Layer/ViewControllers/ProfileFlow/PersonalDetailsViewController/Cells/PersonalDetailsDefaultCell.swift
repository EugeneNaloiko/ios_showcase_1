//
//  PersonalDetailsDefaultCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class PersonalDetailsDefaultCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private let imgArrow: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "img_right_gray")
        return imgView
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 14)
        return lbl
    }()
    
    private var lblSubTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfLightGreyBlueTwo
        lbl.font = UIFont.sfProFont(.regular, size: 14)
        return lbl
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfWhiteSix
        return view
    }()
    
    private let btnOverlay: UIButton = UIButton()
    
    var btnOverlayTappedClosure: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        self.btnOverlay.addTarget(self, action: #selector(self.btnOverlayTapped), for: .touchUpInside)
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.lblTitle)
        self.contentView.addSubview(self.lblSubTitle)
        self.contentView.addSubview(self.imgArrow)
        self.contentView.addSubview(self.separatorView)
        self.contentView.addSubview(self.btnOverlay)
    }
    
    private func setupConstraints() {
        imgArrow.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblSubTitle.translatesAutoresizingMaskIntoConstraints = false
        btnOverlay.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        self.btnOverlay.pinToView(view: self.contentView)
        
        NSLayoutConstraint.activate([
            imgArrow.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            imgArrow.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            imgArrow.heightAnchor.constraint(equalToConstant: 20),
            imgArrow.widthAnchor.constraint(equalToConstant: 20),
            
            lblTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            lblTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            lblTitle.trailingAnchor.constraint(equalTo: self.imgArrow.leadingAnchor, constant: -10),
            
            lblSubTitle.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 4),
            lblSubTitle.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            lblSubTitle.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            lblSubTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            
//            separatorView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 4),
            separatorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
    }
    
    func setLockedStyle() {
        self.imgArrow.image = UIImage(named: "img_lock")
    }
    
    func setTitle(titleText: String) {
        self.lblTitle.text = titleText
    }
    
    func setSubTitle(subTitleText: String) {
        self.lblSubTitle.text = subTitleText
    }
    
    @objc private func btnOverlayTapped() {
        self.btnOverlayTappedClosure?()
    }
    
}
