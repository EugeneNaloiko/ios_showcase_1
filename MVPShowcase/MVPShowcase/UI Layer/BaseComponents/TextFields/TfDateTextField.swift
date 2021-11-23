//
//  TfDateTextField.swift
//
//  Created by Eugene Naloiko
//

import UIKit

class TfDateTextField: UITextField {
    
    var maxLength: Int? = nil
    
    var editingChangedClosure: ((_ newText: String) -> Void)?
    var editingDidEndClosure: ((_ newText: String?) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        prepareUI()
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(self.editingDidEnd(_:)), for: .editingDidEnd)
    }
    
    private func prepareUI() {
        self.textAlignment = .center
        self.textColor = UIColor.tfBlackSix
        self.tintColor = UIColor.tfBlackSix
        self.font = .sfProFont(.bold, size: 24)
        self.backgroundColor = UIColor.clear
        self.keyboardType = .asciiCapableNumberPad
    }
    
    @objc func editingChanged() {
        if let text = self.text, let maxLength = self.maxLength {
            self.text = String(text.prefix(maxLength))
        }
        self.editingChangedClosure?(self.text ?? "")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
    
    @objc private func editingDidEnd(_ sender: UITextField) {
        self.editingDidEndClosure?(sender.text)
    }
    
}


