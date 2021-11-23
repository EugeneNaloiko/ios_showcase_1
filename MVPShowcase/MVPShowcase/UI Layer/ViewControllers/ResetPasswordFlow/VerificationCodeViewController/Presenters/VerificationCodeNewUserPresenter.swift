//
//  VerificationCodeNewUserPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class VerificationCodeNewUserPresenter: BasePresenter, VerificationCodePresenterProtocol {
    
    weak var view: VerificationCodeVCProtocol!
    weak var newPasswordRouter: NewPasswordRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    let email: String
    
    let navigationTitle: String? = L.string("NEW_USER_STRING")
    let titleText = L.string("VERIFY_EMAIL_ADDRESS")
    let descriptionText = L.string("ENTER_6_DIGIT_CODE_FROM_THE_EMAIL_THAT_WAS_SENT_TO_YOU")
    
    init(view: VerificationCodeVCProtocol, newPasswordRouter: NewPasswordRouterProtocol, networkManager: NetworkManagerProtocol, email: String) {
        self.email = email
        super.init()
        self.view = view
        self.newPasswordRouter = newPasswordRouter
        self.networkManager = networkManager
    }
    
    func viewDidLoad() {
        self.callRequestSendVerificationCode(email: self.email)
    }
    
    func validateCode(code: String) {
        if code.count == 6 {
            self.view.hideKeyboard()
            self.callRequestValidateToken(code: code)
        }
    }
    
    private func callRequestValidateToken(code: String) {
        networkManager.validateVerificationCode(email: self.email, verificationCode: code, completion: { [weak self] isValidated in
            guard let sSelf = self else { return }
            if isValidated {
                self?.goToEmailVerifiedSuccessfullyScreen(email: sSelf.email, verificationCode: code)
            } else {
                self?.view.cleanupEnteredCode()
            }
        })
    }
    
    private func callRequestSendVerificationCode(email: String) {
        networkManager.forgotPasswordSendVerificationCode(email: email, completion: nil)
    }
    
    private func goToEmailVerifiedSuccessfullyScreen(email: String, verificationCode: String) {
        self.newPasswordRouter.showEmailVerifiedSuccessfullyScreen(email: email, verificationCode: verificationCode, passwordAction: .create)
    }

}
