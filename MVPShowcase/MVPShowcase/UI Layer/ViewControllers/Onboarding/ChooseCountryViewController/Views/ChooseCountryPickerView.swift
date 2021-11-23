//
//  ChooseCountryPickerView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ChooseCountryPickerView: UIView {
    
    private let lblCountryName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.sfProFont(.regular, size: 16)
        return lbl
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "img_arrow_down_gray")
        return imgView
    }()
    
    private let placeholderText = L.string("COUNTRY_STRING")
    
    var selectionChangedClosure: ((_ sex: Sex) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.displayPlaceholder()
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
    }
    
    private func displayPlaceholder() {
        self.lblCountryName.text = placeholderText
        self.lblCountryName.textColor = UIColor.tfLightGray
        
    }
    
    private func displayCountryName(countryName: String) {
        lblCountryName.text = countryName
        self.lblCountryName.textColor = UIColor.tfBlack
    }
    
    func setCountry(name: String) {
        self.displayCountryName(countryName: name)
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.tfWhiteThree
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.tfVeryLightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    private func addingViews() {
        self.addSubview(self.lblCountryName)
        self.addSubview(self.arrowImageView)
    }
    
    private func setupConstraints() {
        self.lblCountryName.translatesAutoresizingMaskIntoConstraints = false
        self.arrowImageView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            lblCountryName.topAnchor.constraint(equalTo: self.topAnchor),
            lblCountryName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            lblCountryName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            lblCountryName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 7),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
