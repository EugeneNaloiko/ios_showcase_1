//
//  EmailVerifiedSuccessfullyPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class EmailVerifiedSuccessfullyPresenter: BasePresenter, SuccessfullPresenterProtocol {
    
    weak var view: SuccessfullVCProtocol!
    weak var newPasswordRouter: NewPasswordRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    private var email: String!
    private var verificationCode: String!
    private let passwordAction: PasswordAction

    let titleText = L.string("EMAIL_VERIFIED_SUCCESSFULLY")
    let descriptionText = L.string("YOUR_EMAIL_ADDRESS_HAS_BEEN_VERIFIED_SUCCESSFULLY_AND_YOUR_ACCOUNT")
    
    let nextButtonTitle = L.string("CONTINUE_STRING")
    
    init(view: SuccessfullVCProtocol, newPasswordRouter: NewPasswordRouterProtocol, networkManager: NetworkManagerProtocol, email: String, verificationCode: String, passwordAction: PasswordAction) {
        self.passwordAction = passwordAction
        super.init()
        self.view = view
        self.newPasswordRouter = newPasswordRouter
        self.networkManager = networkManager
        self.email = email
        self.verificationCode = verificationCode
    }
    
    func btnNextTapped() {
        newPasswordRouter.showNewPasswordInputScreen(email: email, verificationCode: verificationCode, passwordAction: self.passwordAction)
    }
}
