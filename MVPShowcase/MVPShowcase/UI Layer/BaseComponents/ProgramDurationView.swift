//
//  ProgramDurationView.swift
//
//  Created by Eugene Naloiko
//

import UIKit

final class ProgramDurationView: UIView {
    
    private let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "img_calendar_white_background")
        return imgView
    }()
    
    private let lblDuration: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfLightGreyBlue
        lbl.font = UIFont.sfProFont(.regular, size: 12)
        return lbl
    }()
    
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
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.clear
    }
    
    private func addingViews() {
        self.addSubview(self.imgView)
        self.addSubview(self.lblDuration)
    }
    
    private func setupConstraints() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        lblDuration.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.centerYAnchor.constraint(equalTo: self.lblDuration.centerYAnchor, constant: 0),
            imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 11),
            imgView.widthAnchor.constraint(equalToConstant: 11),
            
            lblDuration.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            lblDuration.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 5),
            lblDuration.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lblDuration.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            lblDuration.heightAnchor.constraint(greaterThanOrEqualToConstant: 17)
        ])
    }
    
    func setDurationText(text: String) {
        self.lblDuration.text = text
    }
    
}
