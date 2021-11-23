//
//  PasswordCreatedSuccessfullyPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class PasswordCreatedSuccessfullyPresenter: BasePresenter, SuccessfullPresenterProtocol {
    
    weak var view: SuccessfullVCProtocol!
    weak var newPasswordRouter: NewPasswordRouterProtocol!
    private var networkManager: NetworkManagerProtocol!

    let titleText = L.string("PASSWORD_CREATED_SUCCESSFULLY")
    let descriptionText = L.string("YOU_HAVE_SUCCESSFULLY_SETUP_YOUR_ACCOUNT")
    
    let nextButtonTitle = L.string("CONTINUE_STRING")
    
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
