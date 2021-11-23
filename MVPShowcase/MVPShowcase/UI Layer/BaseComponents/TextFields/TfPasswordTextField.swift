//
//  TfPasswordTextField.swift
//
//  Created by Eugene Naloiko
//

import UIKit

class TfPasswordTextField: UITextField {
    
    private let btnShowHidePassword = UIButton()
    
    private var padding: UIEdgeInsets
    
    var editingDidBeginClosure: (() -> Void)?
    var editingDidChangeClosure: ((_ newText: String?) -> Void)?
    var editingDidEndClosure: ((_ newText: String?) -> Void)?
    
    override init(frame: CGRect) {
        self.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 40)
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func commonInit() {
        prepareUI()
        self.setTargets()
    }
    
    private func prepareUI() {
        self.btnShowHidePassword.setImage(UIImage(named: "img_show_password"), for: .normal)
        self.btnShowHidePassword.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        self.btnShowHidePassword.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        self.btnShowHidePassword.addTarget(self, action: #selector(self.btnShowHidePasswordTapped(_:)), for: UIControl.Event.touchUpInside)
        
        self.rightView = self.btnShowHidePassword
        
        self.prepareTextField()
    }
    
    private func prepareTextField() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.tfVeryLightGray.cgColor
        self.layer.borderWidth = 1

        self.textAlignment = .left
        self.textColor = UIColor.tfBlackSix
        self.tintColor = UIColor.tfBlackSix
        self.font = .sfProFont(.regular, size: 16)
        self.backgroundColor = UIColor.tfWhiteThree
        self.keyboardType = .asciiCapable
        
        self.rightViewMode = .always

        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
        self.isSecureTextEntry = true
        self.smartQuotesType = .no
        self.textContentType = .password
    }
    
    @objc private func btnShowHidePasswordTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.isSecureTextEntry = false
            self.btnShowHidePassword.setImage(UIImage(named: "img_hide_password"), for: .normal)
        } else {
            self.isSecureTextEntry = true
            self.btnShowHidePassword.setImage(UIImage(named: "img_show_password"), for: .normal)
        }
    }
    
    private func setTargets() {
        self.addTarget(self, action: #selector(self.editingDidBegin(_:)), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.editingChanged(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(self.editingDidEnd(_:)), for: .editingDidEnd)
    }
    
    // MARK: TextFields targets
    
    @objc private func editingDidBegin(_ sender: UITextField) {
        self.editingDidBeginClosure?()
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        self.editingDidChangeClosure?(sender.text)
    }
    
    @objc private func editingDidEnd(_ sender: UITextField) {
        self.editingDidEndClosure?(sender.text)
    }

        
}
