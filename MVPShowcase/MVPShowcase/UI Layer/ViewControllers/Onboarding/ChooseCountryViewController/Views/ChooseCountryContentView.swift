//
//  ChooseCountryContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class ChooseCountryContentView: UIView {
    
    private let chooseCountryPickerView: ChooseCountryPickerView = {
        let view = ChooseCountryPickerView()
        
        return view
    }()
    
    var chooseCountryFieldTappedClosure: (() -> Void)?
    
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
        self.backgroundColor = UIColor.tfWhite
        self.addTapGesture()
    }
    
    private func addingViews() {
        self.addSubview(self.chooseCountryPickerView)
    }
    
    private func setupConstraints() {
        self.chooseCountryPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.chooseCountryPickerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.chooseCountryPickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.chooseCountryPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.chooseCountryFieldTapped(_:)))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc private func chooseCountryFieldTapped(_ sender: UIViewController) {
        self.chooseCountryFieldTappedClosure?()
    }
    
    func setCountry(name: String) {
        self.chooseCountryPickerView.setCountry(name: name)
    }
    
}
