//
//  LoginViewControllerPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class LoginViewControllerPresenter: BasePresenter, LoginVCPresenterProtocol {
    
    weak var view: LoginVCProtocol!
    weak var loginRouter: LoginRouterProtocol!
    var networkManager: NetworkManagerProtocol!
    
    init(view: LoginVCProtocol, loginRouter: LoginRouterProtocol, networkManager: NetworkManagerProtocol) {
        super.init()
        self.view = view
        self.loginRouter = loginRouter
        self.networkManager = networkManager
    }
    
    func btnNextTapped(email: String, password: String) {
        view.startIndicator()
        networkManager.authLogin(email: email, password: password, completion: { [weak self] dataModel, error in
            guard let sSelf = self else { return }
            let tryAgainAction: (() -> Void)? = { [weak self] in
                StorageDataManager.shared.authDataModel = nil
                self?.btnNextTapped(email: email, password: password)
            }
            if let error = error {
                sSelf.view.stopIndicator()
                switch error {
                case .authenticationError, .invalidUsernameOrPassword:
                    self?.view.displayGeneralErrorWith(message: L.string("THE_EMAIL_OR_PASSWORD_YOU_ENTERED_IS_INCORRECT"))
                default:
                    UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: tryAgainAction)
                }
            } else if var data = dataModel {
                data.authenticationToken = "Bearer \(data.authenticationToken)"
                StorageDataManager.shared.authDataModel = data
                sSelf.networkManager.getUserInfo(completion: { [weak self] userModel, errorModel in
                    guard let sSelf = self else { return }
                    DispatchQueue.main.async {
                        if let userDataModel = userModel {
                            sSelf.goToNextScreen(userDataModel: userDataModel)
                        } else {
                            sSelf.view.stopIndicator()
                            UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: tryAgainAction)
                        }
                    }
                })
            }
        })
    }
    
    private func isAllRequiredProfileInfoAreFilled(userDataModel: UserInfoModel) -> Bool {
        guard let profile = userDataModel.profile else { return false }
        guard let countryCode = profile.countryCode, countryCode != "" else { return false }
        guard let _ = profile.sex else { return false }
        guard let birthDate = profile.birthDate, birthDate != "" else { return false }
        guard let _ = profile.currentFitnessLevel else { return false }
        guard let fitnessEquipments = profile.fitnessEquipment, fitnessEquipments != [] else { return false }
        return true
    }
    
    private func goToNextScreen(userDataModel: UserInfoModel) {
        if isAllRequiredProfileInfoAreFilled(userDataModel: userDataModel) {
            StorageDataManager.shared.userDataModel = userDataModel
            self.loginRouter.loginRouterDidFinish()
        } else {
            self.loginRouter.showWelcomeBackScreen(userDataModel: userDataModel)
        }
    }
    
    func btnNewUserTapped() {
        self.loginRouter.showEnterEmailNewUserScreen()
    }
    
    func btnForgotYourPasswordTapped() {
        self.loginRouter.showEnterEmailForgotPasswordScreen()
    }
}
