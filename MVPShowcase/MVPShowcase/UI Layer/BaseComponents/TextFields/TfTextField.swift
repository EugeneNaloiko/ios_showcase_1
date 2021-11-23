//
//  TfTextField.swift
//
//  Created by Eugene Naloiko
//

import UIKit

class TfTextField: UITextField {
    
    private var padding: UIEdgeInsets
    
    var editingDidBeginClosure: (() -> Void)?
    var editingDidChangeClosure: ((_ newText: String?) -> Void)?
    var editingDidEndClosure: ((_ newText: String?) -> Void)?
    
    override init(frame: CGRect) {
        self.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
