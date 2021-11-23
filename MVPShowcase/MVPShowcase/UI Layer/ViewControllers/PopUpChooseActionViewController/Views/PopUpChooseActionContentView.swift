//
//  PopUpChooseActionContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class PopUpChooseActionContentView: UIView {
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfVeryLightGray
        view.layer.masksToBounds = true
        return view
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 16)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private var btnsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 14
        sv.layer.masksToBounds = true
        sv.clipsToBounds = false
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lineView.layer.cornerRadius = self.lineView.bounds.height / 2
    }
    
    private func commonInit() {
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
    }
    
    private func prepareUI() {
        self.backgroundColor = .tfWhite
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func addingViews() {
        self.addSubview(self.lineView)
        self.addSubview(self.lblTitle)
        self.addSubview(self.lblDescription)
        self.addSubview(self.btnsStackView)
    }
    
    private func setupConstraints() {
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        btnsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.lineView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.lineView.heightAnchor.constraint(equalToConstant: 4),
            self.lineView.widthAnchor.constraint(equalToConstant: 32),
            
            self.lblTitle.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 22),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            self.lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            self.lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 14),
            self.lblDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            self.lblDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            btnsStackView.topAnchor.constraint(equalTo: self.lblDescription.bottomAnchor, constant: 14),
            btnsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            btnsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            btnsStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func setData(titleText: String, descriptionText: String) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
    }
    
    func setupButtons(buttons: [PopUpChooseButton]) {
        buttons.forEach({ [weak self] in
            self?.btnsStackView.addArrangedSubview($0)
        })
    }
    
}
