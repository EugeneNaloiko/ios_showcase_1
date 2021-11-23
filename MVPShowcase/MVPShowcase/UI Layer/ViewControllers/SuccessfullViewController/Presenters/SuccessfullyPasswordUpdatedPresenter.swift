//
//  SuccessfullyPasswordUpdatedPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class SuccessfullyPasswordUpdatedPresenter: BasePresenter, SuccessfullPresenterProtocol {
    
    weak var view: SuccessfullVCProtocol!
    weak var profileRouter: ProfileRouterProtocol!
    private var networkManager: NetworkManagerProtocol!

    let titleText = L.string("PASSWORD_UPDATED_SUCCESSFUL")
    let descriptionText = L.string("YOU_HAVE_SUCCESSFULLY_RESET_YOUR_PASSWORD_YOU_ARE_GOOD_TO_GO")
    
    let nextButtonTitle = L.string("THANKS_STRING")
    
    init(view: SuccessfullVCProtocol, profileRouter: ProfileRouterProtocol, networkManager: NetworkManagerProtocol) {
        super.init()
        self.view = view
        self.profileRouter = profileRouter
        self.networkManager = networkManager
    }
    
    func btnNextTapped() {
        self.view.popToProfileVC()
    }
    
}
