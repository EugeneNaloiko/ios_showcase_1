//
//  HowOldAreYouLabelWithFieldView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class HowOldAreYouLabelWithFieldView: UIView {
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlackSix
        lbl.font = UIFont.sfProFont(.semibold, size: 14)
        return lbl
    }()
    
    private let txtValue: TfDateTextField = {
        let txt = TfDateTextField()
        return txt
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        sv.alignment = .center
        return sv
    }()
    
    var textField: TfDateTextField {
        return self.txtValue
    }
    
    var minValue: Int
    var maxValue: Int
    
    var editingChangedClosure: ((_ newText: String) -> Void)?
    var editingDidEndClosure: ((_ newText: String?) -> Void)?
    
    init(minValue: Int, maxValue: Int) {
        self.minValue = minValue
        self.maxValue = maxValue
        super.init(frame: .zero)
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
        self.txtValue.delegate = self
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.clear
    }
    
    private func addingViews() {
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.txtValue)
        self.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.txtValue.heightAnchor.constraint(equalToConstant: 30),
            self.txtValue.widthAnchor.constraint(equalToConstant: 70),
            
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func subscribeClosures() {
        self.txtValue.editingChangedClosure = { [weak self] newText in
            self?.editingChangedClosure?(newText)
        }
        
        self.txtValue.editingDidEndClosure = { [weak self] newText in
            self?.editingDidEndClosure?(newText)
        }
    }
    
    func setTitle(_ titleText: String) {
        self.lblTitle.text = titleText
    }
    
    func setPlaceholder(_ placeholderText: String) {
        self.txtValue.placeholder = placeholderText
    }
    
    func setTextFieldText(text: String) {
        self.txtValue.text = text
    }
    
    func setTextFieldmaxLength(_ maxLength: Int) {
        self.txtValue.maxLength = maxLength
    }
    
    func getTextFieldMaxLength() -> Int? {
        return self.txtValue.maxLength
    }
    
    func setFocusToField() {
        self.txtValue.becomeFirstResponder()
    }
    
}

extension HowOldAreYouLabelWithFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if let manualInputText = textField.text, let range = Range(range, in: manualInputText) {
            
            let inputText = manualInputText.replacingCharacters(in: range, with: string)
            
            if inputText.isEmpty {
                return true
            }
            
            if let maxLength = self.txtValue.maxLength, inputText.count < maxLength {
                return true
            }
            
            if let inputValue = Int64(inputText), (inputValue >= minValue), (inputValue <= maxValue) {
                return true
            }
            
            if self.txtValue.maxLength == 4 {
                return true
            }
        }
        return false
    }
    
}
