//
//  WorkoutInstructionalsCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WorkoutInstructionalsCell: UITableViewCell {
    
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
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfLightGreyBlue
        lbl.font = UIFont.sfProFont(.regular, size: 12)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        return lbl
    }()
    
    private var completedCheckMarkImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "img_completed_checkmark")
        img.isHidden = true
        return img
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
        self.contentView.addSubview(self.completedCheckMarkImageView)
        self.contentView.addSubview(self.btnOverlay)
    }
    
    private func setupConstraints() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgPlayAction.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        completedCheckMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        btnOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            imgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            imgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            imgView.heightAnchor.constraint(equalToConstant: 80),
            imgView.widthAnchor.constraint(equalToConstant: 100),
            
            imgPlayAction.centerXAnchor.constraint(equalTo: self.imgView.centerXAnchor),
            imgPlayAction.centerYAnchor.constraint(equalTo: self.imgView.centerYAnchor),
            
            lblTitle.topAnchor.constraint(equalTo: self.imgView.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 12),
            lblTitle.trailingAnchor.constraint(equalTo: self.completedCheckMarkImageView.leadingAnchor, constant: -5),
            
            lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 5),
            lblDescription.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            lblDescription.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            
            completedCheckMarkImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            completedCheckMarkImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            completedCheckMarkImageView.heightAnchor.constraint(equalToConstant: 24),
            completedCheckMarkImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        self.btnOverlay.pinToView(view: self.contentView)
    }
    
    func setData(titleText: String, descriptionText: String, thumbnail: String) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
        
        //MARK: set image
        self.imgView.image = nil
        downloadAndSetImage(imageURL: thumbnail)
    }
    
    private func downloadAndSetImage(imageURL: String) {
        self.activityIndicator.start(onView: self.imgView)
        self.imgView.sd_setImage(with: URL(string: imageURL), completed: { [weak self] _,_,_,_  in
            self?.activityIndicator.stop()
        })
    }
    
    @objc private func btnOverlayTapped() {
        self.btnOverlayTappedClosure?()
    }
    
}
