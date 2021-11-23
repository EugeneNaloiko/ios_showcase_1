//
//  ButtonForBluredView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ButtonForBluredView: UIView {
    
    private var iconImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfWhite
        lbl.font = UIFont.sfProFont(.regular, size: 10)
        lbl.backgroundColor = UIColor.clear
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        return btn
    }()
    
    var btnTappedClosure: (() -> Void)?
    
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
        self.btn.addTarget(self, action: #selector(self.btnTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    private func prepareUI() {
    }
    
    private func addingViews() {
        self.addSubview(iconImageView)
        self.addSubview(lblTitle)
        self.addSubview(btn)
    }
    
    private func setupConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.iconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.iconImageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            self.iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.lblTitle.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.lblTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.widthAnchor.constraint(equalToConstant: 66)
        ])
        
        self.btn.pinToView(view: self)
    }
    
    @objc func btnTapped(_ sender: UIButton) {
        self.btnTappedClosure?()
    }
    
    func setTitle(titleText: String?) {
        self.lblTitle.text = titleText
    }
    
    func getMoveViewTitle() -> String {
        return self.lblTitle.text ?? ""
    }
    
    func setImage(imageName: String) {
        self.iconImageView.image = UIImage(named: imageName)
    }
    
}
