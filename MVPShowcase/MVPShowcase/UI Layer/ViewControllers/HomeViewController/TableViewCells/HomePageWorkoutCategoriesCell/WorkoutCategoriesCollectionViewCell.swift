//
//  WorkoutCategoriesCollectionViewCell.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

import UIKit
import SDWebImage

final class WorkoutCategoriesCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier: String = String(describing: type(of: self))
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.tfLightGray
        img.clipsToBounds = true
        return img
    }()
    
    private let filterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfGreyishBrownFour40
        return view
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfWhite
        lbl.font = UIFont.sfProFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
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
        self.imgView.addSubview(self.filterView)
        self.imgView.addSubview(self.lblDescription)
        self.contentView.addSubview(self.btnAction)
    }
    
    private func setupConstraints() {
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = false
        
        self.filterView.pinToView(view: self.imgView)
        self.btnAction.pinToView(view: self.contentView)
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 110),
            imgView.heightAnchor.constraint(equalToConstant: 110),
            
            lblDescription.centerYAnchor.constraint(equalTo: self.imgView.centerYAnchor),
            lblDescription.leadingAnchor.constraint(equalTo: self.imgView.leadingAnchor, constant: 5),
            lblDescription.trailingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: -5)
        ])
        
    }
    
    @objc private func tappedOnBtnAction() {
        self.closureTappedOnBtnAction?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
    }
    
    func setData(dataModel: WorkoutCategoriesDataModel) {
        //MARK: set text
        self.lblDescription.text = (dataModel.name ?? "").uppercased()
        
        //MARK: set image
        self.imgView.sd_setImage(with: URL(string: dataModel.smallImage ?? ""), completed: { [weak self] _,_,_,_  in
            self?.activityIndicator.stop()
        })
    }
    
}
