//
//  WorkoutInstructionalsTopHeader.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class WorkoutInstructionalsTopHeader: UIView {
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.tfLightGray
        return img
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
        lbl.font = UIFont.sfProFont(.semibold, size: 24)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblSubtitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfLightGreyBlue
        lbl.font = UIFont.sfProFont(.regular, size: 12)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    var shouldUpdateHeaderHeightClosure: ((_ isAnimated: Bool) -> Void)?
    
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
        setPlayImageHidden()
    }
    
    private func prepareUI() {
        self.backgroundColor = .tfWhite
    }
    
    private func addingViews() {
        self.addSubview(self.imgView)
        self.imgView.addSubview(self.imgPlayAction)
        self.addSubview(self.lblTitle)
        self.addSubview(self.lblSubtitle)
    }
    
    private func setupConstraints() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgPlayAction.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblSubtitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imgView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imgView.heightAnchor.constraint(equalToConstant: 264),
            
            self.imgPlayAction.centerXAnchor.constraint(equalTo: self.imgView.centerXAnchor),
            self.imgPlayAction.centerYAnchor.constraint(equalTo: self.imgView.centerYAnchor),
            self.imgPlayAction.heightAnchor.constraint(equalToConstant: 41),
            self.imgPlayAction.widthAnchor.constraint(equalToConstant: 41),
            
            self.lblTitle.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 14),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            self.lblSubtitle.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 5),
            self.lblSubtitle.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            self.lblSubtitle.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            self.lblSubtitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func setData(workoutData: WorkoutDataModel) {
        lblTitle.text = workoutData.workoutName
        lblSubtitle.text = workoutData.workoutDescription
        
        //MARK: set image
        self.imgView.image = nil
        self.imgView.sd_setImage(with: URL(string: workoutData.thumbnail ?? ""), completed: nil)
    }
    
    func setPlayImageHidden() {
        self.imgPlayAction.isHidden = true
    }
    
}
