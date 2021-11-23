//
//  PopUpChooseButton.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class PopUpChooseButton: UIView {
    
    private let shadowView: BaseShadowView = {
        let view = BaseShadowView(shadowType: .defaultType)
        return view
    }()
    
    private let overallView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfWhite
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
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
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProFont(.regular, size: 14)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    var btnTappedClosure: ((_ buttonTag: Int) -> Void)?
    
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
        self.setupTapGesture()
    }
    
    private func prepareUI() {
        self.backgroundColor = .tfWhite
    }
    
    private func addingViews() {
        self.addSubview(self.shadowView)
        self.addSubview(self.overallView)
        self.overallView.addSubview(self.lblTitle)
        self.overallView.addSubview(self.lblDescription)
        self.overallView.addSubview(self.imgViewArrow)
    }
    
    private func setupConstraints() {
        imgViewArrow.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        
        overallView.pinToView(view: self)
        shadowView.pinToView(view: overallView)
        
        NSLayoutConstraint.activate([
            self.imgViewArrow.centerYAnchor.constraint(equalTo: self.overallView.centerYAnchor),
            self.imgViewArrow.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.imgViewArrow.heightAnchor.constraint(equalToConstant: 16),
            self.imgViewArrow.widthAnchor.constraint(equalToConstant: 10),
            
            self.lblTitle.topAnchor.constraint(equalTo: self.overallView.topAnchor, constant: 16),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.overallView.leadingAnchor, constant: 16),
            self.lblTitle.trailingAnchor.constraint(equalTo: self.imgViewArrow.leadingAnchor, constant: -10),
            
            self.lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 5),
            self.lblDescription.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            self.lblDescription.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            self.lblDescription.bottomAnchor.constraint(equalTo: self.overallView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.btnTappedClosure?(self.tag)
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
    }
    
}
