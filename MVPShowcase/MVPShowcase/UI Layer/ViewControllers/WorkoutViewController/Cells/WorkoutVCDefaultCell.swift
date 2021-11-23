//
//  WorkoutVCDefaultCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WorkoutVCDefaultCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private let overallBackgroundView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor.tfWhiteThree
        return view
    }()
    
    private let imgViewArrow: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "img_arrow_right_orange")
        return img
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 16)
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfLightGreyBlue
        lbl.font = UIFont.sfProFont(.regular, size: 12)
        lbl.numberOfLines = 2
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
    
    private func prepareUI() {
        self.btnOverlay.addTarget(self, action: #selector(self.btnOverlayTapped), for: .touchUpInside)
    }
    
    private func addingViews() {
        self.overallBackgroundView.addSubview(self.imgViewArrow)
        self.overallBackgroundView.addSubview(self.lblTitle)
        self.overallBackgroundView.addSubview(self.lblDescription)
        self.contentView.addSubview(self.overallBackgroundView)
        self.contentView.addSubview(self.btnOverlay)
    }
    
    private func setupConstraints() {
        imgViewArrow.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        overallBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        btnOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        self.overallBackgroundView.pinToView(view: self.contentView, withInsets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        self.btnOverlay.pinToView(view: self.contentView)
        
        NSLayoutConstraint.activate([
            imgViewArrow.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            imgViewArrow.trailingAnchor.constraint(equalTo: self.overallBackgroundView.trailingAnchor, constant: -16),
            imgViewArrow.heightAnchor.constraint(equalToConstant: 14),
            imgViewArrow.widthAnchor.constraint(equalToConstant: 8),
            
            lblTitle.topAnchor.constraint(equalTo: self.overallBackgroundView.topAnchor, constant: 15),
            lblTitle.leadingAnchor.constraint(equalTo: self.overallBackgroundView.leadingAnchor, constant: 15),
            lblTitle.trailingAnchor.constraint(equalTo: self.imgViewArrow.leadingAnchor, constant: -10),
//            lblTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 5),
            lblDescription.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            lblDescription.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            lblDescription.bottomAnchor.constraint(equalTo: self.overallBackgroundView.bottomAnchor, constant: -15),
        ])
    
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
    }
    
    @objc private func btnOverlayTapped() {
        self.btnOverlayTappedClosure?()
    }
    
}
