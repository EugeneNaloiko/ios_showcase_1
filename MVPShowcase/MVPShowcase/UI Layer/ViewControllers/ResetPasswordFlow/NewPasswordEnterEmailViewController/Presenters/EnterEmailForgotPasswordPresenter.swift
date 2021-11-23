//
//  EnterEmailForgotPasswordPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class EnterEmailForgotPasswordPresenter: BasePresenter, NewPasswordEnterEmailPresenterProtocol {
    
    weak var view: NewPasswordEnterEmailVCProtocol!
    weak var newPasswordRouter: NewPasswordRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    let imageName: String = "img_forgot_password"
    
    let navigationTitle: String? = L.string("FORGOT_PASSWORD")
    let titleText = L.string("FORGOT_PASSWORD") + "?"
    let descriptionText = L.string("ENTER_THE_EMAIL_ADDRESS_ASSOSIATED_WITH_YOUR_ACCOUNT")
    
    let nextButtonTitle = L.string("RESET_MY_PASSWORD")
    
    init(view: NewPasswordEnterEmailVCProtocol, newPasswordRouter: NewPasswordRouterProtocol, networkManager: NetworkManagerProtocol) {
        super.init()
        self.view = view
        self.newPasswordRouter = newPasswordRouter
        self.networkManager = networkManager
    }
    
//    func btnNextTapped(email: String) {
//        self.goToVerificationScreen(email: email)
//    }
    
    func btnNextTapped(email: String) {
        networkManager.forgotPasswordSendVerificationCode(email: email, completion: { [weak self] error in
            if error == nil {
                self?.goToVerificationScreen(email: email)
            }
        })
    }
    
    private func goToVerificationScreen(email: String) {
        self.newPasswordRouter.showForgotPasswordVerificationCodeScreen(email: email)
    }
}
