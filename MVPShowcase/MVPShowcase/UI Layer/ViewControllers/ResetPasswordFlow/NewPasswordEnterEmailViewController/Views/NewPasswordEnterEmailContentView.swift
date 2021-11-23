//
//  NewPasswordEnterEmailContentView.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class NewPasswordEnterEmailContentView: UIView {
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfBlack
        lbl.font = UIFont.sfProFont(.semibold, size: 30)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.tfGray
        lbl.font = UIFont.sfProDisplayFont(.regular, size: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let txtEmail: TfTextField = {
        let tf = TfTextField()
        tf.placeholder = L.string("EMAIL")
        tf.returnKeyType = UIReturnKeyType.done
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.textContentType = .emailAddress
        return tf
    }()
    
    var email: String {
        return self.txtEmail.text ?? ""
    }
    
    var emailFieldDidBeginEditingClosure: ((_ fieldmaxY: CGFloat) -> Void)?
    var emailFieldEditingChangedClosure: (() -> Void)?
    var returnButtonTappedClosure: (() -> Void)?
    
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
        self.txtEmail.delegate = self
        self.txtEmail.addTarget(self, action: #selector(self.didBeginEditingEmail(_:)), for: .editingDidBegin)
        self.txtEmail.addTarget(self, action: #selector(self.editingChanged(_:)), for: .editingChanged)
    }
    
    private func prepareUI() {
        self.backgroundColor = UIColor.tfWhite
    }
    
    private func addingViews() {
        self.addSubview(imgView)
        self.addSubview(lblTitle)
        self.addSubview(lblDescription)
        self.addSubview(txtEmail)
    }
    
    private func setupConstraints() {
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = false
        self.txtEmail.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imgView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imgView.widthAnchor.constraint(equalToConstant: 260),
            
            lblTitle.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 30),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            lblDescription.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 20),
            lblDescription.leadingAnchor.constraint(equalTo: self.lblTitle.leadingAnchor, constant: 10),
            lblDescription.trailingAnchor.constraint(equalTo: self.lblTitle.trailingAnchor, constant: -10),
            
            self.txtEmail.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: 30),
            self.txtEmail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            self.txtEmail.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            self.txtEmail.heightAnchor.constraint(equalToConstant: 50),
            self.txtEmail.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    @objc private func didBeginEditingEmail(_ sender: UITextField) {
        self.emailFieldDidBeginEditingClosure?(self.txtEmail.frame.maxY)
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        self.emailFieldEditingChangedClosure?()
    }
    
    func setData(titleText: String, descriptionText: String, imageName: String) {
        self.lblTitle.text = titleText
        self.lblDescription.text = descriptionText
        self.imgView.image = UIImage(named: imageName)
    }
    
    #if DEBUG
    func setTestData() {
        
    }
    #endif
    
}

extension NewPasswordEnterEmailContentView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.returnButtonTappedClosure?()
        return true
    }
}
