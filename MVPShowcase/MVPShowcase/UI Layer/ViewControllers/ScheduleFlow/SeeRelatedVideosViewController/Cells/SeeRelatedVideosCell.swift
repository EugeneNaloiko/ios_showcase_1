//
//  SeeRelatedVideosCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class SeeRelatedVideosCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    private let activityIndicator = BaseActivityIndicator(backgroundColor: UIColor.tfBeige, size: .large)
    
    private let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 8
        imgView.backgroundColor = UIColor.tfLightGray
        return imgView
    }()
    
    private let imgPlayAction: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "img_play_action")
        return imgView
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfLightGreyBlue
        lbl.font = UIFont.sfProFont(.regular, size: 12)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 5
        sv.alignment = .fill
        return sv
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
        self.imgView.addSubview(self.imgPlayAction)
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.lblTitle)
        self.contentView.addSubview(self.lblDescription)
        self.contentView.addSubview(self.stackView)
        self.contentView.addSubview(self.btnOverlay)
    }
    
    private func setupConstraints() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgPlayAction.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        btnOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            imgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            imgView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -12),
            imgView.heightAnchor.constraint(equalToConstant: 80),
            imgView.widthAnchor.constraint(equalToConstant: 100),
            
            imgPlayAction.centerXAnchor.constraint(equalTo: self.imgView.centerXAnchor),
            imgPlayAction.centerYAnchor.constraint(equalTo: self.imgView.centerYAnchor),
            
            lblTitle.topAnchor.constraint(equalTo: self.imgView.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 12),
            lblTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 5),
            lblDescription.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            lblDescription.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: self.lblDescription.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: self.lblDescription.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.lblDescription.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.self.contentView.bottomAnchor, constant: -12)
        ])
        
        self.btnOverlay.pinToView(view: self.contentView)
    }
    
    func setData(title: String, descriptionText: String, thumbnail: String) {
        self.lblTitle.text = title
        self.lblDescription.text = descriptionText
        
        self.imgView.image = nil
        downloadAndSetImage(imageURL: thumbnail)
    }
    
    func setVideoTypes(videoTypes: [String]) {
        self.stackView.arrangedSubviews.forEach({ [weak self] subview in
            self?.stackView.removeArrangedSubview(subview)
        })
        for type in videoTypes {
            let lblType: UILabel = {
                let lbl = UILabel()
                lbl.textAlignment = .left
                lbl.textColor = UIColor.tfLightGreyBlue
                lbl.font = UIFont.sfProFont(.semibold, size: 12)
                return lbl
            }()
            
            lblType.text = type.uppercased()
            self.stackView.addArrangedSubview(lblType)
        }
        
        
    }
    
    private func downloadAndSetImage(imageURL: String) {
        self.activityIndicator.start(onView: self.imgView)
        
        self.imgView.sd_setImage(with: URL(string: imageURL), completed: { [weak self] _,_,_,_  in
            guard let sSelf = self else { return }
            sSelf.activityIndicator.stop()
        })
    }
    
    @objc private func btnOverlayTapped() {
        self.btnOverlayTappedClosure?()
    }
    
}

