//
//  ProfileDefaultCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ProfileDefaultCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private let activityIndicator = BaseActivityIndicator(backgroundColor: UIColor.tfBeige, size: .large)
    
    private let overallView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfWhiteSix
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    private let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 8
        imgView.backgroundColor = UIColor.tfLightGray
        return imgView
    }()
    
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
//        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
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
    
    func makeCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        self.overallView.layer.cornerRadius = cornerRadius
        self.overallView.layer.maskedCorners = maskedCorners
    }
    
    private func prepareUI() {
        self.btnOverlay.addTarget(self, action: #selector(self.btnOverlayTapped), for: .touchUpInside)
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.overallView)
        self.overallView.addSubview(self.imgView)
        self.overallView.addSubview(self.lblTitle)
        self.overallView.addSubview(self.imgArrow)
        self.overallView.addSubview(self.btnOverlay)
    }
    
    private func setupConstraints() {
        overallView.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgArrow.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        btnOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        self.btnOverlay.pinToView(view: self.overallView)
        
        NSLayoutConstraint.activate([
            
            overallView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            overallView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 24),
            overallView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -24),
            overallView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            imgView.topAnchor.constraint(equalTo: self.overallView.topAnchor, constant: 12),
            imgView.bottomAnchor.constraint(equalTo: self.overallView.bottomAnchor, constant: -12),
            imgView.leadingAnchor.constraint(equalTo: self.overallView.leadingAnchor, constant: 16),
            imgView.heightAnchor.constraint(equalToConstant: 24),
            imgView.widthAnchor.constraint(equalToConstant: 24),
            
            lblTitle.centerYAnchor.constraint(equalTo: self.imgView.centerYAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 12),
            lblTitle.trailingAnchor.constraint(equalTo: self.imgArrow.leadingAnchor, constant: -10),
            
            imgArrow.centerYAnchor.constraint(equalTo: self.overallView.centerYAnchor),
            imgArrow.trailingAnchor.constraint(equalTo: self.overallView.trailingAnchor, constant: -16),
            imgArrow.heightAnchor.constraint(equalToConstant: 12),
            imgArrow.widthAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    func setData(titleText: String, imageName: String) {
        self.lblTitle.text = titleText
        self.imgView.image = UIImage(named: imageName)
    }
    
    @objc private func btnOverlayTapped() {
        self.btnOverlayTappedClosure?()
    }
    
}
