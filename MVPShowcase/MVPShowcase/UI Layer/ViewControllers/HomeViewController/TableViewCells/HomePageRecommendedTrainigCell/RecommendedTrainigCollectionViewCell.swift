//
//  RecommendedTrainigCollectionViewCell.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class RecommendedTrainigCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: type(of: self))
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.tfLightGray
        return img
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 14)
        return lbl
    }()
    
    private let activityIndicator = BaseActivityIndicator(backgroundColor: UIColor.tfBeige, size: .large)
    
    private let btnAction: UIButton = UIButton()
    
    var closureTappedOnBtnAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareUI()
        self.addingViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        self.btnAction.addTarget(self, action: #selector(self.tappedOnBtnAction), for: .touchUpInside)
        self.imgView.backgroundColor = .tfBeige
    }
    
    private func addingViews() {
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.lblDescription)
        self.contentView.addSubview(self.btnAction)
    }
    
    private func setupConstraints() {
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 200),
            imgView.heightAnchor.constraint(equalToConstant: 116),
            
            lblDescription.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 10),
            lblDescription.leadingAnchor.constraint(equalTo: self.imgView.leadingAnchor),
            lblDescription.trailingAnchor.constraint(equalTo: self.imgView.trailingAnchor),
            lblDescription.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -3),
        ])
        
        self.btnAction.pinToView(view: self.contentView)
    }
    
    @objc private func tappedOnBtnAction() {
        self.closureTappedOnBtnAction?()
    }
    
    func setData(dataModel: ProgramDataModel) {
        //MARK: set text
        self.lblDescription.text = dataModel.programDetails?.title
        
        //MARK: set image
        self.imgView.image = nil
        self.activityIndicator.start(onView: self.imgView)
        self.imgView.sd_setImage(with: URL(string: dataModel.programDetails?.thumbnail ?? ""), completed: { [weak self] _,_,_,_  in
            self?.activityIndicator.stop()
        })
    }
    
}
