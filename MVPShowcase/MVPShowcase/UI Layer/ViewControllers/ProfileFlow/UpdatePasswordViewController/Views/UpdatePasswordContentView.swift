//
//  UpdatePasswordContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class UpdatePasswordContentView: UIView {
    
    private let txtNewPassword: TfPasswordTextField = {
        let tf = TfPasswordTextField()
        tf.placeholder = L.string("NEW_PASSWORD")
        tf.tag = 0
        return tf
    }()
    
    private let lblNewPasswordError: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfCoral
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.isHidden = true
        return lbl
    }()
    
    private let txtConfirmPassword: TfPasswordTextField = {
        let tf = TfPasswordTextField()
        tf.returnKeyType = UIReturnKeyType.go
        tf.placeholder = L.string("CONFIRM_PASSWORD")
        tf.tag = 1
        return tf
    }()
    
    private let lblGeneralError: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfCoral
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.isHidden = true
        return lbl
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .fill
        return sv
    }()
    
    var newPassword: String {
        return self.txtNewPassword.text ?? ""
    }
    
    var confirmPassword: String {
        return self.txtConfirmPassword.text ?? ""
    }
    
    var txtNewPasswordReturnKeyboardbuttonTappedClosure: (() -> Void)?
    var txtConfirmPasswordReturnKeyboardButtonTappedClosure: (() -> Void)?
    
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
        self.suscribeClosures()
        self.txtNewPassword.delegate = self
        self.txtConfirmPassword.delegate = self
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.tfWhite
    }
    
    private func addingViews() {
        self.stackView.addArrangedSubview(self.txtNewPassword)
        self.stackView.addArrangedSubview(self.lblNewPasswordError)
        self.stackView.addArrangedSubview(self.txtConfirmPassword)
        self.stackView.addArrangedSubview(self.lblGeneralError)
        
        self.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            txtNewPassword.heightAnchor.constraint(equalToConstant: 50),
            
            txtConfirmPassword.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func suscribeClosures() {
        self.txtNewPassword.editingDidBeginClosure = { [weak self] in
            self?.setNewPasswordError(message: "")
            self?.setGeneralError(message: "")
        }
        
        self.txtNewPassword.editingDidEndClosure = { [weak self] newText in
            guard let sSelf = self else { return }
            if !sSelf.newPassword.isValidCPasswordRequirements() {
                sSelf.setNewPasswordError(message: L.string("PASSWORD_MUST_BE_AT_LEAST_6_CHARACTERS_WITH_A_NUMBER"))
            }
        }
        
        self.txtConfirmPassword.editingDidBeginClosure = { [weak self] in
            self?.setGeneralError(message: "")
        }
    }
    
    func setNewPasswordError(message: String) {
        self.lblNewPasswordError.text = message
        if let text = self.lblNewPasswordError.text, !text.isEmpty {
            self.lblNewPasswordError.isHidden = false
        } else {
            self.lblNewPasswordError.isHidden = true
        }
    }
    
    func setGeneralError(message: String) {
        self.lblGeneralError.text = message
        if let text = self.lblGeneralError.text, !text.isEmpty {
            self.lblGeneralError.isHidden = false
        } else {
            self.lblGeneralError.isHidden = true
        }
    }
    
}

extension UpdatePasswordContentView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.txtConfirmPassword.becomeFirstResponder()
            self.txtNewPasswordReturnKeyboardbuttonTappedClosure?()
        } else if textField.tag == 1 {
            self.endEditing(true)
            self.txtConfirmPasswordReturnKeyboardButtonTappedClosure?()
        }
        return true
    }
    
}
