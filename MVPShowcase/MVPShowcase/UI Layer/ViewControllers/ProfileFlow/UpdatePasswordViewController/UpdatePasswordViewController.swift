//
//  UpdatePasswordViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

final class UpdatePasswordViewController: BaseViewController {
    
    var presenter: UpdatePasswordPresenterProtocol!
    
    private let contentView = UpdatePasswordContentView()
    
    private let btnNext: BaseButton = {
        let btn = BaseButton(style: .orange)
        btn.setTitle(L.string("UPDATE_PASSWORD"), for: UIControl.State.normal)
        return btn
    }()
    
    private var btnNextBottomAnchor: NSLayoutConstraint?
    private var defaultBottomConstant: CGFloat = -30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupUI()
        self.addingViews()
        self.setupConstraints()
        self.subscribeClosures()
        self.addGestureHideKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .tfWhite
    }
    
    private func setupNavigationBar() {
        self.setNavigationBarBackArrowButton()
        self.setNavigationTitle(title: L.string("UPDATE_PASSWORD"))
    }
    
    private func addingViews() {
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.btnNext)
    }
    
    private func setupConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        
        self.btnNextBottomAnchor = self.btnNext.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: defaultBottomConstant)
        self.btnNextBottomAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.btnNext.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.btnNext.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
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
        
        self.presenter.btnNextTapped(newPassword: self.contentView.newPassword,
                                     confirmedPassword: self.contentView.confirmPassword)
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
        
        //MARK: Keyboard will Show logic
        self.keyboardWillShowClosure = { [weak self] keyboardFrame in
            guard let sSelf = self else { return }
            let keyboardOffset: CGFloat = 5
            sSelf.btnNextBottomAnchor?.constant = -(keyboardFrame.size.height + keyboardOffset)
        }
        
        //MARK: Keyboard will Hide logic
        self.keyboardWillHideClosure = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.btnNextBottomAnchor?.constant = sSelf.defaultBottomConstant
        }
    }
    
}

extension UpdatePasswordViewController: UpdatePasswordVCProtocol {
    
    func startIndicator() {
        self.btnNext.startIndicator()
    }
    
    func stopIndicator() {
        self.btnNext.stopIndicator()
    }
    
    func displayGeneralErrorWith(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.setGeneralError(message: message)
        }
    }
    
}
