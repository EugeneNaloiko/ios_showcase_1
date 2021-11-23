//
//  FitnessLevelView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class FitnessLevelView: UIView {
    
    private let imgViewCheckmark: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.bold, size: 14)
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 12)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let shadowView: BaseShadowView = {
        let view = BaseShadowView(shadowType: .defaultTypeBottomRightOffset)
        return view
    }()
    
    private let overallView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfWhiteFive
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()

    
    private let btn = UIButton()
    
    var cardDidSelectClosure: ((_ sender: UIButton) -> Void)?
    
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
        
        self.btn.addTarget(self, action: #selector(self.cardDidSelect(_:)), for: UIControl.Event.touchUpInside)
    }
    
    private func prepareUI() {
//        self.backgroundColor = UIColor.tfWhiteFive
    }
    
    private func addingViews() {
        self.addSubview(shadowView)
        self.addSubview(overallView)
        
        self.overallView.addSubview(imgViewCheckmark)
        self.overallView.addSubview(lblTitle)
        self.overallView.addSubview(lblDescription)
        self.overallView.addSubview(btn)
    }
    
    private func setupConstraints() {
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        imgViewCheckmark.translatesAutoresizingMaskIntoConstraints = false
        
        overallView.pinToView(view: self)
        shadowView.pinToView(view: overallView)
        
        NSLayoutConstraint.activate([
            self.imgViewCheckmark.centerYAnchor.constraint(equalTo: self.overallView.centerYAnchor),
            self.imgViewCheckmark.trailingAnchor.constraint(equalTo: self.overallView.trailingAnchor, constant: -16),
            self.imgViewCheckmark.heightAnchor.constraint(equalToConstant: 25),
            self.imgViewCheckmark.widthAnchor.constraint(equalToConstant: 25),
            
            lblTitle.topAnchor.constraint(equalTo: self.overallView.topAnchor, constant: 16),
            lblTitle.leadingAnchor.constraint(equalTo: self.overallView.leadingAnchor, constant: 16),
            lblTitle.trailingAnchor.constraint(equalTo: self.imgViewCheckmark.leadingAnchor, constant: -16),
            
            lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 5),
            lblDescription.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            lblDescription.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            lblDescription.bottomAnchor.constraint(equalTo: self.overallView.bottomAnchor, constant: -16),
        ])
        
        self.btn.pinToView(view: overallView)
    }
    
    @objc private func cardDidSelect(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            self.cardDidSelectClosure?(sender)
        }
    }
    
    func setSelectedState() {
        self.btn.isSelected = true
        self.imgViewCheckmark.image = UIImage(named: "img_male_or_female_checkmark_selected")
        self.overallView.layer.borderWidth = 1
        self.overallView.layer.borderColor = UIColor.tfOrangish.cgColor
    }
    
    func setUnSelectedState() {
        self.btn.isSelected = false
        self.imgViewCheckmark.image = nil
        self.overallView.layer.borderWidth = 0
        self.overallView.layer.borderColor = nil
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
    }
    
}
