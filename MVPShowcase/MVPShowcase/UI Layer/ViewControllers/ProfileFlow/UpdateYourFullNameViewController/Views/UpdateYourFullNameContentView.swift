//
//  UpdateYourFullNameContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class UpdateYourFullNameContentView: UIView {
    
    private let txtFirstName: TfTextField = {
        let tf = TfTextField()
        tf.placeholder = L.string("FIRST_NAME")
        tf.returnKeyType = UIReturnKeyType.done
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .words
        tf.spellCheckingType = .no
        tf.textContentType = .name
        return tf
    }()
    
    private let txtLastName: TfTextField = {
        let tf = TfTextField()
        tf.placeholder = L.string("LAST_NAME")
        tf.returnKeyType = UIReturnKeyType.done
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .words
        tf.spellCheckingType = .no
        tf.textContentType = .name
        return tf
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        sv.alignment = .fill
        return sv
    }()
    
    var firstNameChangedClosure: ((_ newFirstName: String) -> Void)?
    var lastNameChangedClosure: ((_ newLastName: String) -> Void)?
    
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
        self.backgroundColor = UIColor.clear
        
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        
        self.txtFirstName.addTarget(self, action: #selector(self.firstNameChanged(_:)), for: .editingChanged)
        self.txtLastName.addTarget(self, action: #selector(self.lastNameChanged(_:)), for: .editingChanged)
    }
    
    private func addingViews() {
        self.stackView.addArrangedSubview(self.txtFirstName)
        self.stackView.addArrangedSubview(self.txtLastName)
        
        self.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        txtFirstName.translatesAutoresizingMaskIntoConstraints = false
        txtLastName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.txtFirstName.heightAnchor.constraint(equalToConstant: 50),
            self.txtLastName.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func firstNameChanged(_ sender: UITextField) {
        self.firstNameChangedClosure?(sender.text ?? "")
    }
    
    @objc func lastNameChanged(_ sender: UITextField) {
        self.lastNameChangedClosure?(sender.text ?? "")
    }
    
    func setInitialState(firstName: String?, lastName: String?) {
        self.txtFirstName.text = firstName
        self.txtLastName.text = lastName
    }
    
}

extension UpdateYourFullNameContentView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
