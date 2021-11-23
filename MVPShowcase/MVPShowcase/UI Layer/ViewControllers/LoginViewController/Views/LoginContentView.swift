//
//  LoginContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class LoginContentView: UIView {
    
    private let txtEmail: TfTextField = {
        let tf = TfTextField()
        tf.placeholder = L.string("EMAIL")
        tf.returnKeyType = UIReturnKeyType.next
        tf.spellCheckingType = .no
        tf.autocapitalizationType = .none
        tf.smartQuotesType = .no
        tf.textContentType = .emailAddress
        tf.autocorrectionType = .no
        tf.tag = 0
        return tf
    }()
    
    private let lblEmailError: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfCoral
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.isHidden = true
        return lbl
    }()
    
    private let txtPassword: TfPasswordTextField = {
        let tf = TfPasswordTextField()
        tf.returnKeyType = UIReturnKeyType.go
        tf.placeholder = L.string("PASSWORD")
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
    
    private let btnNewUser: UIButton = {
        let btn = UIButton()
        btn.setTitle("\(L.string("NEW_USER_STRING"))?", for: UIControl.State.normal)
        btn.titleLabel?.font = .sfProFont(.regular, size: 16)
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(UIColor.tfOrangish, for: .normal)
        return btn
    }()
    
    var email: String {
        return self.txtEmail.text ?? ""
    }
    
    var password: String {
        return self.txtPassword.text ?? ""
    }
    
    var txtEmailReturnKeyboardbuttonTappedClosure: (() -> Void)?
    var txtPasswordReturnKeyboardbuttonTappedClosure: (() -> Void)?
    var btnNewUserTappedClosure: (() -> Void)?
    
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
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.btnNewUser.addTarget(self, action: #selector(btnNewUserTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.tfWhite
    }
    
    private func addingViews() {
        self.stackView.addArrangedSubview(self.txtEmail)
        self.stackView.addArrangedSubview(self.lblEmailError)
        self.stackView.addArrangedSubview(self.txtPassword)
        self.stackView.addArrangedSubview(self.lblGeneralError)
        
        self.addSubview(stackView)
        self.addSubview(btnNewUser)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        btnNewUser.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            txtEmail.heightAnchor.constraint(equalToConstant: 50),
            
            txtPassword.heightAnchor.constraint(equalToConstant: 50),
            
            btnNewUser.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 10),
            btnNewUser.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            btnNewUser.heightAnchor.constraint(equalToConstant: 50),
            btnNewUser.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
    
    @objc private func btnNewUserTapped(_ sender: UIButton) {
        self.btnNewUserTappedClosure?()
    }
    
    private func suscribeClosures() {
        self.txtEmail.editingDidBeginClosure = { [weak self] in
            self?.setEmailError(message: "")
            self?.setGeneralError(message: "")
        }
        
        self.txtEmail.editingDidEndClosure = { [weak self] newText in
            guard let sSelf = self else { return }
            if !sSelf.email.isValidEmail() {
                sSelf.setEmailError(message: L.string("PLEASE_ENTER_A_VALID_EMAIL"))
            }
        }
        
        self.txtPassword.editingDidBeginClosure = { [weak self] in
            self?.setGeneralError(message: "")
        }
    }
    
    func setEmailError(message: String) {
        self.lblEmailError.text = message
        if let text = self.lblEmailError.text, !text.isEmpty {
            self.lblEmailError.isHidden = false
        } else {
            self.lblEmailError.isHidden = true
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
    
    #if DEBUG
    func setTestData() {
        
    }
    #endif
    
}

extension LoginContentView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.txtPassword.becomeFirstResponder()
            self.txtEmailReturnKeyboardbuttonTappedClosure?()
        } else if textField.tag == 1 {
            self.endEditing(true)
            self.txtPasswordReturnKeyboardbuttonTappedClosure?()
        }
        return true
    }
    
}
