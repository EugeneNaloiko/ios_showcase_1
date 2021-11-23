//
//  ConfirmDetailsContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ConfirmDetailsContentView: UIView {
    
    private let btnEdit: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.tfOrangish
        btn.setImage(UIImage(named: "img_edit"), for: .normal)
        return btn
    }()
    
    private let shadowView: BaseShadowView = {
        let view = BaseShadowView(shadowType: .defaultTypeBottomRightOffset)
        return view
    }()
    
    private let overallView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfWhiteFive
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let countryView: ConfirmDetailsItemView = {
        let view = ConfirmDetailsItemView(imageName: "img_country_icon", titleText: L.string("COUNTRY_STRING"))
        
        return view
    }()
    
    private let genderView: ConfirmDetailsItemView = {
        let view = ConfirmDetailsItemView(imageName: "img_gender", titleText: L.string("GENDER"))
        
        return view
    }()
    
    private  let dateOfBirthView: ConfirmDetailsItemView = {
        let view = ConfirmDetailsItemView(imageName: "img_calendar", titleText: L.string("DATE_OF_BIRTH"))
        return view
    }()
    
    private  let fitnessLevelView: ConfirmDetailsItemView = {
        let view = ConfirmDetailsItemView(imageName: "img_fitness_level", titleText: L.string("FITNESS_LEVEL"))
        return view
    }()
    
    private  let equipmentsView: ConfirmDetailsItemView = {
        let view = ConfirmDetailsItemView(imageName: "img_equipments", titleText: L.string("EQUIPMENT"))
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.alignment = .top
        return sv
    }()
    
    var btnEditTappedClosure: (() -> Void)?
    
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
        
        self.btnEdit.addTarget(self, action: #selector(self.btnEditTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.clear
    }
    
    private func addingViews() {
        self.addSubview(shadowView)
        self.addSubview(overallView)
        
        self.stackView.addArrangedSubview(self.genderView)
        self.stackView.addArrangedSubview(self.dateOfBirthView)
        self.stackView.addArrangedSubview(self.fitnessLevelView)
        self.stackView.addArrangedSubview(self.equipmentsView)
        self.stackView.addArrangedSubview(self.countryView)
        
        self.overallView.addSubview(stackView)
        self.overallView.addSubview(btnEdit)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        btnEdit.translatesAutoresizingMaskIntoConstraints = false
        
        overallView.pinToView(view: self)
        shadowView.pinToView(view: overallView)
        
        stackView.pinToView(view: self.overallView, withInsets: UIEdgeInsets(top: 25, left: 20, bottom: 20, right: 40))
        
        NSLayoutConstraint.activate([
            btnEdit.topAnchor.constraint(equalTo: self.overallView.topAnchor),
            btnEdit.trailingAnchor.constraint(equalTo: self.overallView.trailingAnchor),
            btnEdit.widthAnchor.constraint(equalToConstant: 40),
            btnEdit.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupCountryViewDetails(countryName: String) {
        self.countryView.setupSelectedItems(selectedItems: [countryName])
    }
    
    func setupGenderViewDetails(detailsItems: [String]) {
        self.genderView.setupSelectedItems(selectedItems: detailsItems)
    }
    
    func setupDateOfBirthViewDetails(detailsItems: [String]) {
        self.dateOfBirthView.setupSelectedItems(selectedItems: detailsItems)
    }
    
    func setupFitnessLevelViewDetails(detailsItems: [String]) {
        self.fitnessLevelView.setupSelectedItems(selectedItems: detailsItems)
    }
    
    func setupEquipmentsViewDetails(detailsItems: [String]) {
        self.equipmentsView.setupSelectedItems(selectedItems: detailsItems)
    }
    
    @objc private func btnEditTapped(_ sender: UIButton) {
        self.btnEditTappedClosure?()
    }
    
}
