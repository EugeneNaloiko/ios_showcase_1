//
//  LoginViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    var presenter: LoginVCPresenterProtocol!
    
    private let headerView = OnboardingHeaderViewWithLogo()
    private let loginContentView = LoginContentView()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("LOGIN_STRING"), for: UIControl.State.normal)
        return btn
    }()
    
    private let btnForgotYourPassword: UIButton = {
        let btn = UIButton()
        btn.setTitle(L.string("FORGOT_YOUR_PASSWORD"), for: UIControl.State.normal)
        btn.titleLabel?.font = .sfProFont(.regular, size: 16)
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(UIColor.tfOrangish, for: .normal)
        return btn
    }()
    
    private let lblEnvironmentChanged: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.tfCoral
        lbl.font = UIFont.sfProFont(.semibold, size: 16)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.isHidden = true
        return lbl
    }()
    
    private var btnForgotYourPasswordBottomAnchor: NSLayoutConstraint?
    private var defaultBottomConstant: CGFloat = -30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.addGestureHideKeyboard()
        self.addChangeEnvironmentGesture()
        
        #if DEBUG
        self.loginContentView.setTestData()
        #endif
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .tfWhite
        self.headerView.setData(titleText: L.string("LOGIN_STRING"), descriptionText: nil)
    }
    
    private func addingViews() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.loginContentView)
        self.view.addSubview(self.lblEnvironmentChanged)
        self.view.addSubview(self.btnNext)
        self.view.addSubview(self.btnForgotYourPassword)
    }
    
    private func setupConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.loginContentView.translatesAutoresizingMaskIntoConstraints = false
        self.lblEnvironmentChanged.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        self.btnForgotYourPassword.translatesAutoresizingMaskIntoConstraints = false
        
        self.btnForgotYourPasswordBottomAnchor = self.btnForgotYourPassword.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: defaultBottomConstant)
        self.btnForgotYourPasswordBottomAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.loginContentView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 10),
            self.loginContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.loginContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.btnForgotYourPassword.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.btnForgotYourPassword.heightAnchor.constraint(equalToConstant: 30),
            
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.btnNext.bottomAnchor.constraint(equalTo: self.btnForgotYourPassword.topAnchor, constant: -5),
            
            self.lblEnvironmentChanged.topAnchor.constraint(equalTo: self.loginContentView.bottomAnchor, constant: 15),
            self.lblEnvironmentChanged.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.lblEnvironmentChanged.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        ])
        
    }
    
    private func addChangeEnvironmentGesture() {
        // 5 taps on HeaderView -> Change env
        let sevenTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sevenTapHeader))
        sevenTapRecognizer.numberOfTapsRequired = 7
        self.headerView.addGestureRecognizer(sevenTapRecognizer)
    }
    
    @objc func sevenTapHeader() {
        switch StorageDataManager.shared.environment {
        case .PROD:
            StorageDataManager.shared.environment = .STAGING
        case .STAGING:
            StorageDataManager.shared.environment = .DEV
        case .DEV:
            StorageDataManager.shared.environment = .PROD
        }
        self.displayEnvironmentChangedLabel(message: "Environment changed to \(StorageDataManager.shared.environment.rawValue)")
        #if DEBUG
        print("Environment BaseURL changed to ", Constants.BaseURL.environmentBaseURL)
        #endif
    }
        
    private func displayEnvironmentChangedLabel(message: String) {
        lblEnvironmentChanged.text = message
        lblEnvironmentChanged.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: { [weak self] in
            self?.lblEnvironmentChanged.isHidden = true
        })
    }
    
    @objc private func btnForgotYourPasswordTapped() {
        self.presenter.btnForgotYourPasswordTapped()
    }
    
    private func performContinueActionIfPossible() {
        guard self.isAllRequiredFieldsFilled() else {
            self.loginContentView.setGeneralError(message: L.string("PLEASE_ENTER_EMAIL_AND_PASSWORD"))
            return
        }
        
        guard self.loginContentView.email.isValidEmail() else {
            self.loginContentView.setEmailError(message: L.string("PLEASE_ENTER_A_VALID_EMAIL"))
            return
        }
        
        self.presenter.btnNextTapped(email: self.loginContentView.email, password: self.loginContentView.password)
    }
    
    private func subscribeClosures() {
        self.btnForgotYourPassword.addTarget(self, action: #selector(btnForgotYourPasswordTapped), for: UIControl.Event.touchUpInside)
        
        self.btnNext.didTapClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.performContinueActionIfPossible()
        }
        
        self.loginContentView.txtPasswordReturnKeyboardbuttonTappedClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.performContinueActionIfPossible()
        }
        
        self.loginContentView.btnNewUserTappedClosure = { [weak self] in
            self?.presenter.btnNewUserTapped()
        }
        
        //MARK: Keyboard will Show logic
        self.keyboardWillShowClosure = { [weak self] keyboardFrame in
            guard let sSelf = self else { return }
            let keyboardOffset: CGFloat = 5
            sSelf.btnForgotYourPasswordBottomAnchor?.constant = -(keyboardFrame.size.height + keyboardOffset)
        }
        
        //MARK: Keyboard will Hide logic
        self.keyboardWillHideClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.btnForgotYourPasswordBottomAnchor?.constant = sSelf.defaultBottomConstant
        }
    }
    
    private func isAllRequiredFieldsFilled() -> Bool {
        guard !self.loginContentView.email.isEmpty && !self.loginContentView.password.isEmpty else {
            return false
        }
        return true
    }
    
    func displayEmailErrorWithText(_ text: String) {
        print(text)
    }
    
}

extension LoginViewController: LoginVCProtocol {
    
    func startIndicator() {
        self.btnNext.startIndicator()
    }
    
    func stopIndicator() {
        self.btnNext.stopIndicator()
    }
    
    func displayGeneralErrorWith(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.loginContentView.setGeneralError(message: message)
        }
    }
    
}

extension LoginViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
