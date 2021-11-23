//
//  CreateNewPasswordViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

enum PasswordAction {
    case create
    case update
}

final class CreateNewPasswordViewController: BaseViewController {
    
    weak var newPasswordRouter: NewPasswordRouter!
    let networkManager: NetworkManagerProtocol!
    
    let email: String
    let verificationCode: String
    let passwordAction: PasswordAction
    
    private let contentView: CreateNewPasswordContentView = {
        let view = CreateNewPasswordContentView()
        view.setData(titleText: L.string("CREATE_NEW_PASSWORD"),
                     descriptionText: "\(L.string("ENTER_A_NEW_AND_SECURE_PASSWORD_FOR_YOUR_ACCOUNT")) \(L.string("PASSWORD_MUST_BE_AT_LEAST_6_CHARACTERS_WITH_A_NUMBER"))")
        return view
    }()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("RESET_MY_PASSWORD"), for: UIControl.State.normal)
        return btn
    }()
    
    private var bottomFieldY: CGFloat?
    private var viewHeight = UIScreen.main.bounds.height
    
    init(newPasswordRouter: NewPasswordRouter, networkManager: NetworkManagerProtocol, email: String, verificationCode: String, passwordAction: PasswordAction) {
        self.networkManager = networkManager
        self.verificationCode = verificationCode
        self.email = email
        self.passwordAction = passwordAction
        super.init(nibName: nil, bundle: nil)
        self.newPasswordRouter = newPasswordRouter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.addGestureHideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .tfWhite
    }
    
    private func addingViews() {
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
    }
    
    private func performContinueActionIfPossible() {
        guard !self.contentView.newPassword.isEmpty else {
            self.contentView.setNewPasswordError(message: L.string("ENTER_A_NEW_AND_SECURE_PASSWORD_FOR_YOUR_ACCOUNT"))
            return
        }
        
        guard self.contentView.newPassword.isValidCPasswordRequirements() else {
            self.contentView.setNewPasswordError(message: L.string("PASSWORD_MUST_BE_AT_LEAST_6_CHARACTERS_WITH_A_NUMBER"))
            return
        }
        
        guard self.contentView.newPassword == self.contentView.confirmPassword else {
            self.contentView.setGeneralError(message: L.string("BOTH_PASSWORDS_MUST_MATCH"))
            return
        }

        self.performSetPasswordAction(newPassword: self.contentView.newPassword, confirmedPassword: self.contentView.confirmPassword)
    }
    
    private func performSetPasswordAction(newPassword: String, confirmedPassword: String) {
        guard newPassword == confirmedPassword else { return }
        networkManager.setPassword(newPassword: newPassword, email: email, token: verificationCode, completion: { error in
            if error == nil {
                switch self.passwordAction {
                case .create:
                    self.newPasswordRouter.showPasswordCreatedSuccessfullyScreen()
                case .update:
                    self.newPasswordRouter.showPasswordResetSuccessfullyScreen()
                }
            }
        })
    }
    
    private func subscribeClosures() {
        self.btnNext.didTapClosure = { [weak self] in
                guard let sSelf = self else { return }
                sSelf.performContinueActionIfPossible()
        }
        
        self.contentView.txtConfirmPasswordReturnKeyboardButtonTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.performContinueActionIfPossible()
        }
        
        self.contentView.textFieldDidBeginEditingClosure = { [weak self] fieldmaxY in
            guard let sSelf = self else { return }
            sSelf.bottomFieldY = sSelf.contentView.frame.origin.y + fieldmaxY
        }
        
        self.contentView.returnButtonTappedClosure = { [weak self] in
            self?.view.endEditing(true)
        }
        
        //MARK: Keyboard will Show logic
        self.keyboardWillShowClosure = { [weak self] keyboardFrame in
            guard let sSelf = self else { return }
            
            let keyboardOffset: CGFloat = 5
            sSelf.viewHeight = sSelf.view.bounds.height
            guard sSelf.bottomFieldY != nil else { return }
            let bottomFieldYWithOffset = sSelf.bottomFieldY! + keyboardOffset
            
            let keyboardY = sSelf.viewHeight - keyboardFrame.size.height
            let offsetWhenKeyboardAppeared = bottomFieldYWithOffset - keyboardY
            
            if bottomFieldYWithOffset > keyboardY {
                sSelf.view.frame = CGRect(x: 0, y: -offsetWhenKeyboardAppeared, width: sSelf.view.bounds.width, height: sSelf.view.bounds.height)
            }
        }
        
        //MARK: Keyboard will Hide logic
        self.keyboardWillHideClosure = { [weak self] in
            guard let sSelf = self else { return }
//            var viewFrameOriginY: CGFloat = 0
//            if sSelf.navigationController?.navigationBar.isTranslucent == false {
//                viewFrameOriginY = sSelf.navigationController?.navigationBar.frame.maxY ?? 0
//            }
            sSelf.view.frame = CGRect(x: 0, y: 0, width: sSelf.view.bounds.width, height: sSelf.viewHeight)
        }
        
    }
    
}
