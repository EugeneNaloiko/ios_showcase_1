//
//  SeeAllWithArrowButton.swift
//
//  Created by Eugene Naloiko
//

import UIKit

class SeeAllWithArrowButton: UIView {
    
    var btnTappedClosure: (() -> Void)?
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.baselineAdjustment = .alignCenters
        lbl.textColor = UIColor.tfBeige
        lbl.font = UIFont.sfProDisplayFont(.semibold, size: 12)
        lbl.text = L.string("SEE_ALL")
        return lbl
    }()
    
    private let iconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "img_arrow_right_black")
        return imgView
    }()
    
    private let btnAction = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.addingViews()
        self.setupConstraints()
        self.btnAction.addTarget(self, action: #selector(self.btnTapped), for: .touchUpInside)
    }
    
    private func addingViews() {
        self.addSubview(self.lblTitle)
        self.addSubview(self.iconImageView)
        self.addSubview(self.btnAction)
    }
    
    private func setupConstraints() {
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.btnAction.translatesAutoresizingMaskIntoConstraints = false
        
        let const = self.lblTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        const.priority = UILayoutPriority(999)
        const.isActive = true
        
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            lblTitle.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 5),
            lblTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            iconImageView.leadingAnchor.constraint(equalTo: lblTitle.trailingAnchor, constant: 10),
            iconImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            iconImageView.centerYAnchor.constraint(equalTo: self.lblTitle.centerYAnchor, constant: 0),
            iconImageView.heightAnchor.constraint(equalToConstant: 13),
            iconImageView.widthAnchor.constraint(equalToConstant: 7),
        ])
        
        self.btnAction.pinToView(view: self)
    }
    
    @objc private func btnTapped() {
        self.btnTappedClosure?()
    }
    
    func setTitle(_ text: String) {
        lblTitle.text = text
    }
    
    func setTintColor(_ color: UIColor) {
        lblTitle.textColor = color
        iconImageView.image = UIImage(named: "imgArrowRight")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate).tint(with: color)
    }
}
