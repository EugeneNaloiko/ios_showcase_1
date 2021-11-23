//
//  NoRelatedVideosView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class NoRelatedVideosView: UIView {
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "img_no_program_available")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 16)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = L.string("NO_RELATED_VIDEOS_FOR THIS_WORKOUT")
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
        self.backgroundColor = UIColor.tfWhite
    }
    
    private func addingViews() {
        self.addSubview(imgView)
        self.addSubview(lblTitle)
    }
    
    private func setupConstraints() {
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imgView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imgView.widthAnchor.constraint(equalToConstant: 292),
            self.imgView.heightAnchor.constraint(equalToConstant: 292),
            
            lblTitle.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 10),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            lblTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    func setData(titleText: String) {
        self.lblTitle.text = titleText
    }
    
}
