//
//  OTPTextField.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class OTPTextField: UITextField {
    
    private var style: OTPTextFieldStyle
    private var maxLength: Int = 1
    
    var editingChangedClosure: ((_ txtField: UITextField) -> Void)?
    var editingDidEndClosure: ((_ txtField: UITextField) -> Void)?
    
    var closureDeleteBackward: ((_ txtField: UITextField) -> Void)?
    
    required init(style: OTPTextFieldStyle) {
        self.style = style
        super.init(frame: .zero)
        self.commonInit()
        self.setupConstraints()
        self.setStyle(style: self.style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        print(#function)
        self.closureDeleteBackward?(self)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
    
    func commonInit() {
        self.setupUI()
        self.setupConstraints()
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(self.editingDidEnd(_:)), for: .editingDidEnd)
    }
    
    @objc private func editingDidBegin(_ sender: UITextField) {
        self.setStyle(style: .orange)
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        if let text = sender.text {
            self.text = String(text.prefix(self.maxLength))
        }
        self.editingChangedClosure?(self)
    }
    
    @objc private func editingDidEnd(_ sender: UITextField) {
        self.setStyle(style: .gray)
        self.editingDidEndClosure?(sender)
    }
    
    private func setupUI() {
        textAlignment = .center
        keyboardType = .asciiCapableNumberPad
        textColor = UIColor.tfBlack
        font = UIFont.sfProFont(.semibold, size: 24)
        tintColor = UIColor.tfBlack
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 48),
            self.widthAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    func setStyle(style: OTPTextFieldStyle) {
        self.style = style
        
        self.font = style.settings.font
        self.backgroundColor = style.settings.backgroundColor
        self.textColor = style.settings.fontColor
        self.layer.borderColor = style.settings.borderColor
        self.layer.borderWidth = style.settings.borderWidth ?? 0
    }
    
}
