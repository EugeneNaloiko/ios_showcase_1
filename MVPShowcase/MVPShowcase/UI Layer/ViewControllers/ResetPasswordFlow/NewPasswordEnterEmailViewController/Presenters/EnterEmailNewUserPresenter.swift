//
//  EnterEmailNewUserPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class EnterEmailNewUserPresenter: BasePresenter, NewPasswordEnterEmailPresenterProtocol {
    
    weak var view: NewPasswordEnterEmailVCProtocol!
    weak var newPasswordRouter: NewPasswordRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    let imageName: String = "img_logo_orange"
    
    let navigationTitle: String? = L.string("NEW_USER_STRING")
    let titleText = L.string("WELCOME_STRING")
    let descriptionText = L.string("PROVIDE_YOUR_EMAIL_BELOW_TO_GAIN_ACCESS_TO_YOUR_ACCOUNT")
    
    let nextButtonTitle = L.string("LOGIN_STRING")
    
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
        self.newPasswordRouter.showNewUserVerificationCodeScreen(email: email)
    }

}
