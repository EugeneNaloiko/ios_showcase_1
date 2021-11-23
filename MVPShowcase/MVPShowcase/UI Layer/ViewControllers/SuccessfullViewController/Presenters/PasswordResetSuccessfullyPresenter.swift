//
//  PasswordResetSuccessfullyPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class PasswordResetSuccessfullyPresenter: BasePresenter, SuccessfullPresenterProtocol {
    
    weak var view: SuccessfullVCProtocol!
    weak var newPasswordRouter: NewPasswordRouterProtocol!
    private var networkManager: NetworkManagerProtocol!

    let titleText = L.string("PASSWORD_RESET_SUCCESSFULLY")
    let descriptionText = L.string("YOU_HAVE_SUCCESSFULLY_RESET_YOUR_PASSWORD_YOU_ARE_GOOD_TO_GO_LOGIN_TO_YOUR_ACCOUNT")
    
    let nextButtonTitle = L.string("BACK_TO_LOGIN")
    
    init(view: SuccessfullVCProtocol, newPasswordRouter: NewPasswordRouterProtocol, networkManager: NetworkManagerProtocol) {
        super.init()
        self.view = view
        self.newPasswordRouter = newPasswordRouter
        self.networkManager = networkManager
    }
    
    func btnNextTapped() {
        newPasswordRouter.backToLoginScreen()
    }
}
