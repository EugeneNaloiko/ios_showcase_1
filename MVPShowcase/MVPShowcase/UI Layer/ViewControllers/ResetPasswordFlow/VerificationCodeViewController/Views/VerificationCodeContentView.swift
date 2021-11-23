//
//  VerificationCodeContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class VerificationCodeContentView: UIView {
    
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 30)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblSubtitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProFont(.regular, size: 14)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    var txtFieldsArray: [OTPTextField] = []
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.semanticContentAttribute = .forceLeftToRight
        return sv
    }()
    
    private let btnOpenEmailApp: BaseButton = {
        let btn = BaseButton(style: .lightOrange)
        btn.setTitle(L.string("OPEN_EMAIL_APP"), for: UIControl.State.normal)
        return btn
    }()
    
    var codeChangedClosure: ((String) -> Void)?
    var btnOpenEmailAppTappedClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupFieldsArray()
        addingViews()
        setupConstraints()
        prepareUI()
        addActions()
    }
    
    private func addingViews() {
        for field in self.txtFieldsArray {
            self.stackView.addArrangedSubview(field)
        }
        self.addSubview(self.lblTitle)
        self.addSubview(self.lblSubtitle)
        self.addSubview(self.stackView)
        self.addSubview(self.btnOpenEmailApp)
    }
    
    private func setupConstraints() {
        
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblSubtitle.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.btnOpenEmailApp.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: self.topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            lblSubtitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            lblSubtitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblSubtitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: lblSubtitle.bottomAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            btnOpenEmailApp.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 24),
            btnOpenEmailApp.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            btnOpenEmailApp.widthAnchor.constraint(equalToConstant: 210),
            btnOpenEmailApp.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
    func showKeyboard() {
        guard txtFieldsArray.count > 0 else { return }
        txtFieldsArray[0].becomeFirstResponder()
    }
    
    func cleanupEnteredCode() {
        txtFieldsArray.forEach({$0.text = ""})
        showKeyboard()
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.clear
    }
    
    private func setupFieldsArray() {
        for item in 0...5 {
            let field = OTPTextField(style: .gray)
            field.tag = item
            field.editingChangedClosure = { [weak self] textField in
                self?.fieldDidChanged(sender: textField)
            }
            txtFieldsArray.append(field)
        }
    }
    
    private func fieldDidChanged(sender: UITextField) {
        switch sender.tag {
        case 0:
            inputDataToTextField(previousTextField: nil, currentTextField: txtFieldsArray[0], nextTextField: txtFieldsArray[1])
        case 1:
            inputDataToTextField(previousTextField: txtFieldsArray[0], currentTextField: txtFieldsArray[1], nextTextField: txtFieldsArray[2])
        case 2:
            inputDataToTextField(previousTextField: txtFieldsArray[1], currentTextField: txtFieldsArray[2], nextTextField: txtFieldsArray[3])
        case 3:
            inputDataToTextField(previousTextField: txtFieldsArray[2], currentTextField: txtFieldsArray[3], nextTextField: txtFieldsArray[4])
        case 4:
            inputDataToTextField(previousTextField: txtFieldsArray[3], currentTextField: txtFieldsArray[4], nextTextField: txtFieldsArray[5])
        case 5 :
            inputDataToTextField(previousTextField: txtFieldsArray[4], currentTextField: txtFieldsArray[5], nextTextField: nil)
        default:
            break
        }
        
        var code = ""
        
        for item in txtFieldsArray {
            code.append(item.text ?? "")
        }
        
        self.codeChangedClosure?(code)
        
    }
    
    private func inputDataToTextField(previousTextField: UITextField?, currentTextField: UITextField, nextTextField: UITextField?) {
        guard let text = currentTextField.text else { return }
        if text.count == 1 && !currentTextField.isBackSpaceWasPressed() {
            if let nextTextField = nextTextField {
                if nextTextField.text?.count != 1 {
                    nextTextField.becomeFirstResponder()
                }
            }
            //            else {
            //                currentTextField.resignFirstResponder()
            //            }
        } else if currentTextField.isBackSpaceWasPressed() {
            if let txtPrevious = previousTextField {
                txtPrevious.becomeFirstResponder()
            }
            print("isBackSpaceWasPressed")
        }
    }
    
    private func checkTextFieldIfBackSpaceTouched(previousTextField: UITextField?, currentTextField: UITextField) {
        guard let text = currentTextField.text else { return }
        if text.isEmpty {
            if currentTextField.isBackSpaceWasPressed() {
                if previousTextField != nil {
                    previousTextField?.becomeFirstResponder()
                }
            }
        }
    }
    
    private func addActions() {
        btnOpenEmailApp.addTarget(self, action: #selector(self.btnOpenEmailAppTapped), for: .touchUpInside)
    }
    
    @objc private func btnOpenEmailAppTapped() {
        self.btnOpenEmailAppTappedClosure?()
    }
    
    func setData(title: String, subTitle: String) {
        self.lblTitle.text = title
        self.lblSubtitle.text = subTitle
    }
    
}
