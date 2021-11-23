//
//  ConfirmDetailsItemView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ConfirmDetailsItemView: UIView {
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.bold, size: 14)
        return lbl
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .leading
        return sv
    }()
    
    var cardDidSelectClosure: ((_ sender: UIButton) -> Void)?
    var btnEditTappedClosure: (() -> Void)?
    
    init(imageName: String, titleText: String) {
        super.init(frame: .zero)
        self.imageView.image = UIImage(named: imageName)
        self.lblTitle.text = titleText
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
        self.addSubview(imageView)
        self.addSubview(lblTitle)
        self.addSubview(stackView)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 40),
            self.imageView.widthAnchor.constraint(equalToConstant: 40),
            
            lblTitle.topAnchor.constraint(equalTo: self.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 10),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 14)
        ])
        
    }
    
    func setupSelectedItems(selectedItems: [String]) {
        var lblsArraySelectedDetails: [UILabel] = []
        selectedItems.forEach({
            let lblSelectedItem: UILabel = {
                let lbl = UILabel()
                lbl.textAlignment = .left
                lbl.textColor = UIColor.tfSlate
                lbl.font = UIFont.sfProFont(.regular, size: 12)
                return lbl
            }()
            
            lblSelectedItem.text = $0
            lblsArraySelectedDetails.append(lblSelectedItem)
        })
        
        lblsArraySelectedDetails.forEach({ [weak self] in
            guard let sSelf = self else { return }
            sSelf.stackView.addArrangedSubview($0)
        })
    }
    
}
