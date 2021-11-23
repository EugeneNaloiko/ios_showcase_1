//
//  SkipTodayPopUpViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit
import SDWebImage

class SkipTodayPopUpViewController: BasePopUpViewController {
    
    private let overallView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfWhite
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        return img
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
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let btnContinue: BaseButton = {
        let btn = BaseButton(style: .orange)
        return btn
    }()
    
    private let btnCancel: BaseButton = {
        let btn = BaseButton(style: .lightOrange)
        return btn
    }()
    
    var btnContinueTappedClosure: (() -> Void)?
    var btnCancelTappedClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addingViews()
        self.setupConstraints()
        
        self.btnContinue.didTapClosure = { [weak self] in
            self?.btnContinueTappedClosure?()
            self?.motionDismissViewController()
        }
        
        self.btnCancel.didTapClosure = { [weak self] in
            self?.btnCancelTappedClosure?()
            self?.motionDismissViewController()
        }
    }
    
    private func addingViews() {
        self.view.addSubview(self.overallView)
        self.overallView.addSubview(self.btnContinue)
        self.overallView.addSubview(self.btnCancel)
        self.overallView.addSubview(self.lblDescription)
        self.overallView.addSubview(self.lblTitle)
        self.overallView.addSubview(self.imgView)
    }
    
    private func setupConstraints() {
        self.overallView.translatesAutoresizingMaskIntoConstraints = false
        self.btnContinue.translatesAutoresizingMaskIntoConstraints = false
        self.btnCancel.translatesAutoresizingMaskIntoConstraints = false
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.overallView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.overallView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.overallView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.overallView.heightAnchor.constraint(greaterThanOrEqualToConstant: 370)
        ])
        
        NSLayoutConstraint.activate([
            self.imgView.topAnchor.constraint(equalTo: self.overallView.topAnchor, constant: 45),
            self.imgView.centerXAnchor.constraint(equalTo: self.overallView.centerXAnchor),
            self.imgView.heightAnchor.constraint(equalToConstant: 154),
            self.lblTitle.bottomAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 43),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.overallView.leadingAnchor, constant: 32),
            self.lblTitle.trailingAnchor.constraint(equalTo: self.overallView.trailingAnchor, constant: -32),
            
            self.lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 8),
            self.lblDescription.leadingAnchor.constraint(equalTo: self.overallView.leadingAnchor, constant: 32),
            self.lblDescription.trailingAnchor.constraint(equalTo: self.overallView.trailingAnchor, constant: -32),
            self.lblDescription.bottomAnchor.constraint(equalTo: self.btnContinue.topAnchor, constant: -45)
        ])
        
        
        NSLayoutConstraint.activate([
            self.btnCancel.bottomAnchor.constraint(equalTo: self.overallView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.btnCancel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnCancel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.btnContinue.bottomAnchor.constraint(equalTo: self.btnCancel.topAnchor, constant: -20),
            self.btnContinue.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnContinue.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
        ])
        
    }
    
    func setData(imageName: String, titleText: String, descriptionText: String, buttonContinueTitle: String, buttonCancelTitle: String) {
        self.imgView.image = UIImage(named: imageName)
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
        self.btnContinue.setTitle(buttonContinueTitle, for: .normal)
        self.btnCancel.setTitle(buttonCancelTitle, for: .normal)
    }
    
}

