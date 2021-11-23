//
//  SexCard.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class SexCard: UIView {
    
    private let imgViewCheckmark: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let grayCircle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfWhiteFour
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    private let imgViewIcon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlackSix
        lbl.font = UIFont.sfProFont(.regular, size: 14)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.grayCircle.layer.cornerRadius = self.grayCircle.frame.height / 2
    }

    
    private func commonInit() {
        self.addingViews()
        self.setupConstraints()
        
        self.btn.addTarget(self, action: #selector(self.cardDidSelect(_:)), for: UIControl.Event.touchUpInside)
    }
    
    private func addingViews() {
        self.addSubview(shadowView)
        self.addSubview(overallView)
        overallView.addSubview(self.grayCircle)
        overallView.addSubview(self.imgViewIcon)
        overallView.addSubview(self.imgViewCheckmark)
        overallView.addSubview(self.lblTitle)
        overallView.addSubview(self.btn)
    }
    
    private func setupConstraints() {
        imgViewCheckmark.translatesAutoresizingMaskIntoConstraints = false
        grayCircle.translatesAutoresizingMaskIntoConstraints = false
        imgViewIcon.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        overallView.pinToView(view: self)
        shadowView.pinToView(view: overallView)
        
        NSLayoutConstraint.activate([
            self.imgViewCheckmark.topAnchor.constraint(equalTo: overallView.topAnchor, constant: 16),
            self.imgViewCheckmark.trailingAnchor.constraint(equalTo: overallView.trailingAnchor, constant: -16),
            self.imgViewCheckmark.heightAnchor.constraint(equalToConstant: 25),
            self.imgViewCheckmark.widthAnchor.constraint(equalToConstant: 25),
            
            self.grayCircle.centerYAnchor.constraint(equalTo: overallView.centerYAnchor),
            self.grayCircle.centerXAnchor.constraint(equalTo: overallView.centerXAnchor),
            self.grayCircle.heightAnchor.constraint(equalToConstant: 70),
            self.grayCircle.widthAnchor.constraint(equalToConstant: 70),
            
            self.imgViewIcon.centerYAnchor.constraint(equalTo: self.grayCircle.centerYAnchor),
            self.imgViewIcon.centerXAnchor.constraint(equalTo: self.grayCircle.centerXAnchor),
            
            self.lblTitle.topAnchor.constraint(equalTo: self.imgViewIcon.bottomAnchor, constant: 20),
            self.lblTitle.centerXAnchor.constraint(equalTo: overallView.centerXAnchor),
            
            self.btn.topAnchor.constraint(equalTo: overallView.topAnchor),
            self.btn.leadingAnchor.constraint(equalTo: overallView.leadingAnchor),
            self.btn.trailingAnchor.constraint(equalTo: overallView.trailingAnchor),
            self.btn.bottomAnchor.constraint(equalTo: overallView.bottomAnchor),
        ])
        
        self.layoutIfNeeded()
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
        self.imgViewCheckmark.image = UIImage(named: "img_male_or_female_checkmark_unselected")
        self.overallView.layer.borderWidth = 0
        self.overallView.layer.borderColor = nil
    }
    
    func setData(imageName: String, titleText: String) {
        self.imgViewIcon.image = UIImage(named: imageName)
        self.lblTitle.text = titleText
    }
    
}
