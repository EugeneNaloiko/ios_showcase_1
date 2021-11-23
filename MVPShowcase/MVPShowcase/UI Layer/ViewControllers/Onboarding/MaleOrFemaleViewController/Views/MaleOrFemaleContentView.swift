//
//  MaleOrFemaleContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class MaleOrFemaleContentView: UIView {
    
    private let maleCard: SexCard = {
        let card = SexCard()
        card.setData(imageName: "img_male_icon", titleText: L.string("MALE"))
        return card
    }()
    
    private let femaleCard: SexCard = {
        let card = SexCard()
        card.setData(imageName: "img_female_icon", titleText: L.string("FEMALE"))
        return card
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    
    var selectionChangedClosure: ((_ sex: Sex) -> Void)?
    
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
        self.subscribeClosures()
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.tfWhite
    }
    
    private func addingViews() {
        self.stackView.addArrangedSubview(maleCard)
        self.stackView.addArrangedSubview(femaleCard)
        
        self.addSubview(self.stackView)
    }
    
    private func setupConstraints() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        maleCard.translatesAutoresizingMaskIntoConstraints = false
        femaleCard.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            maleCard.heightAnchor.constraint(equalToConstant: 240),
            femaleCard.heightAnchor.constraint(equalTo: maleCard.heightAnchor, multiplier: 1.0),
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
    }
    
    private func subscribeClosures() {
        self.maleCard.cardDidSelectClosure = { [weak self] sender in
            guard let sSelf = self else { return }
            if sender.isSelected {
                sSelf.maleCard.setSelectedState()
                sSelf.femaleCard.setUnSelectedState()
                sSelf.selectionChangedClosure?(.male)
            }
        }
        
        self.femaleCard.cardDidSelectClosure = { [weak self] sender in
            guard let sSelf = self else { return }
            if sender.isSelected {
                sSelf.femaleCard.setSelectedState()
                sSelf.maleCard.setUnSelectedState()
                sSelf.selectionChangedClosure?(.female)
            }
        }
    }
    
    func setInitialState(sex: Sex?) {
        switch sex {
        case .male:
            self.maleCard.setSelectedState()
        case .female:
            self.femaleCard.setSelectedState()
        case .none:
            self.maleCard.setUnSelectedState()
            self.femaleCard.setUnSelectedState()
        }
    }
    
}
