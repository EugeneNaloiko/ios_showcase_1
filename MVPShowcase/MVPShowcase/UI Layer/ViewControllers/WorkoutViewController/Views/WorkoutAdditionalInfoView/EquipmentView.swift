//
//  EquipmentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class EquipmentView: UIView {
    
    var estimatedWidth: CGFloat = 0
    
    private let lblEquipmentTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 10)
        return lbl
    }()
    
    private let verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
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
        self.addSubview(self.lblEquipmentTitle)
        self.addSubview(self.verticalStackView)
    }
    
    private func setupConstraints() {
        lblEquipmentTitle.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lblEquipmentTitle.topAnchor.constraint(equalTo: self.topAnchor),
            lblEquipmentTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblEquipmentTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            verticalStackView.topAnchor.constraint(equalTo: self.lblEquipmentTitle.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setTitle(titleText: String) {
        lblEquipmentTitle.text = titleText
    }
    
    func setValues(equipmentUrls: [String], estimatedWidth: CGFloat) {
        self.estimatedWidth = estimatedWidth
        
        var equipmentImageViews: [UIImageView] = []
        equipmentUrls.forEach({ iconUrl in
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: iconUrl), completed: { _,_,_,_  in
                equipmentImageViews.append(imageView)
            })
            
        })
        self.setupEquipments(equipmentImageViews: equipmentImageViews)
    }
    
    private func setupEquipments(equipmentImageViews: [UIImageView]) {
        
        self.verticalStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        guard equipmentImageViews.count > 0 else { return }
        
        let imagesInOneLine = Int(estimatedWidth/16)
        
        var linesDataSource: [[UIImageView]] = []
        var oneLineDataSource: [UIImageView] = []
        
        for (index, equipmentImageView) in equipmentImageViews.enumerated() {
            
            if oneLineDataSource.count < imagesInOneLine {
                oneLineDataSource.append(equipmentImageView)
            }  else if index == (imagesInOneLine) {
                linesDataSource.append(oneLineDataSource)
                oneLineDataSource = []
                oneLineDataSource.append(equipmentImageView)
            } else if (equipmentImageViews.count % (imagesInOneLine - 1)) == 0 {
                linesDataSource.append(oneLineDataSource)
                oneLineDataSource = []
                oneLineDataSource.append(equipmentImageView)
            } else {
                linesDataSource.append(oneLineDataSource)
            }
            if index == equipmentImageViews.count - 1 {
                if oneLineDataSource.count <= imagesInOneLine && !oneLineDataSource.isEmpty {
                    linesDataSource.append(oneLineDataSource)
                }
            }
            
        }
        
        for line in linesDataSource {
            let equipmentImagesStackView: UIStackView = {
                let sv = UIStackView()
                sv.axis = .horizontal
                sv.alignment = .center
                sv.distribution = .equalCentering
                return sv
            }()
            
            let view = UIView()
            view.addSubview(equipmentImagesStackView)
            
            equipmentImagesStackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                equipmentImagesStackView.topAnchor.constraint(equalTo: view.topAnchor),
                equipmentImagesStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
                equipmentImagesStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
                equipmentImagesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                equipmentImagesStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            for equipmentImageView in line {
                let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
                imgView.contentMode = .scaleAspectFill
                
                imgView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imgView.heightAnchor.constraint(equalToConstant: 16),
                    imgView.widthAnchor.constraint(equalToConstant: 16)
                ])
                
                imgView.image = equipmentImageView.image
                
                equipmentImagesStackView.addArrangedSubview(imgView)
            }
            self.verticalStackView.addArrangedSubview(view)
        }
    }
    
}
