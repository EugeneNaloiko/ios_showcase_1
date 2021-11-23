//
//  UpdatePasswordFromProfilePresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class UpdatePasswordFromProfilePresenter: BasePresenter, UpdatePasswordPresenterProtocol {
    
    weak var view: UpdatePasswordVCProtocol!
    weak var profileRouter: ProfileRouterProtocol!
    var networkManager: NetworkManagerProtocol!
    
    init(view: UpdatePasswordVCProtocol, profileRouter: ProfileRouterProtocol, networkManager: NetworkManagerProtocol) {
        super.init()
        self.view = view
        self.profileRouter = profileRouter
        self.networkManager = networkManager
    }
    
    func btnNextTapped(newPassword: String, confirmedPassword: String) {
        view.startIndicator()
        networkManager.updatePassword(newPassword: newPassword,
                                      completion: { [weak self] _, _ in
                                        self?.view.stopIndicator()
                                        self?.profileRouter.showPasswordUpdatedSuccessfullScreen()
                                      })
    }
    
}
