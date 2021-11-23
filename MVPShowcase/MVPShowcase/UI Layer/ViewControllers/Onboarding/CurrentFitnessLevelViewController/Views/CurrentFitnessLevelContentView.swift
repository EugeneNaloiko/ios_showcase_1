//
//  CurrentFitnessLevelContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class CurrentFitnessLevelContentView: UIView {
    
    private let lowLevelView: FitnessLevelView = {
        let card = FitnessLevelView()
        card.setData(titleText: L.string("NOVICE_STRING"),
                     descriptionText: L.string("I_AM_NEW_TO_WORKING_OUT_OR_HAVE_LITTLE_TO_NO_EXPERIENCE"))
        return card
    }()
    
    private let middleLevelView: FitnessLevelView = {
        let card = FitnessLevelView()
        card.setData(titleText: L.string("EXPERIENCED_STRING"),
                     descriptionText: L.string("I_WORKOUT_REGULARLY_AT_LEAST_TWO_OR_THREE_TIMES_A_WEEK"))
        return card
    }()
    
    private let highLevelView: FitnessLevelView = {
        let card = FitnessLevelView()
        card.setData(titleText: L.string("PROFESSIONAL_STRING"),
                     descriptionText: L.string("I_WORKOUT_DAILY_OR_MULTIPLE_TIMES_DAY"))
        return card
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .fill
        return sv
    }()
    
    var selectionChangedClosure: ((_ currentLevel: FitnessLevel) -> Void)?
    
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
        self.backgroundColor = UIColor.clear
    }
    
    private func addingViews() {
        self.stackView.addArrangedSubview(self.highLevelView)
        self.stackView.addArrangedSubview(self.middleLevelView)
        self.stackView.addArrangedSubview(self.lowLevelView)
        
        self.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func subscribeClosures() {
        self.lowLevelView.cardDidSelectClosure = { [weak self] sender in
            guard let sSelf = self else { return }
            if sender.isSelected {
                sSelf.lowLevelView.setSelectedState()
                sSelf.middleLevelView.setUnSelectedState()
                sSelf.highLevelView.setUnSelectedState()
                sSelf.selectionChangedClosure?(.startingLevel)
            }
        }
        
        self.middleLevelView.cardDidSelectClosure = { [weak self] sender in
            guard let sSelf = self else { return }
            if sender.isSelected {
                sSelf.middleLevelView.setSelectedState()
                sSelf.lowLevelView.setUnSelectedState()
                sSelf.highLevelView.setUnSelectedState()
                sSelf.selectionChangedClosure?(.okLevel)
            }
        }
        
        self.highLevelView.cardDidSelectClosure = { [weak self] sender in
            guard let sSelf = self else { return }
            if sender.isSelected {
                sSelf.highLevelView.setSelectedState()
                sSelf.lowLevelView.setUnSelectedState()
                sSelf.middleLevelView.setUnSelectedState()
                sSelf.selectionChangedClosure?(.veryFitLevel)
            }
        }
    }
    
    func setInitialState(finessLevel: FitnessLevel?) {
        switch finessLevel {
        case .startingLevel:
            self.lowLevelView.setSelectedState()
        case .okLevel:
            self.middleLevelView.setSelectedState()
        case .veryFitLevel:
            self.highLevelView.setSelectedState()
        case .none:
            self.lowLevelView.setUnSelectedState()
            self.middleLevelView.setUnSelectedState()
            self.highLevelView.setUnSelectedState()
        }
    }
    
}
