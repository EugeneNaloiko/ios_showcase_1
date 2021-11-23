//
//  NewPasswordRouter.swift
//
//  Created by Eugene Naloiko
//

import UIKit

//MARK: - NewPasswordRouter Protocol
protocol NewPasswordRouterProtocol: RouterProtocol {
    var navigationController: BaseNavigationController! { get }
    
    func showEnterEmailForgotPasswordScreen()
    func showForgotPasswordVerificationCodeScreen(email: String)
    
    func showEnterEmailNewUserScreen()
    func showNewUserVerificationCodeScreen(email: String)
    
    func showEmailVerifiedSuccessfullyScreen(email: String, verificationCode: String, passwordAction: PasswordAction)
    
    func showNewPasswordInputScreen(email: String, verificationCode: String, passwordAction: PasswordAction)
    
    func showPasswordResetSuccessfullyScreen()
    
    func showPasswordCreatedSuccessfullyScreen()
    
    func backToLoginScreen()
}

//MARK: - ProgramsRouterProtocol
class NewPasswordRouter: NewPasswordRouterProtocol {
    
    weak var navigationController: BaseNavigationController!
    weak var networkManager: NetworkManagerProtocol!
    
    init(networkManager: NetworkManagerProtocol, navigationController: BaseNavigationController) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
    func showEnterEmailForgotPasswordScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = NewPasswordEnterEmailViewController(newPasswordRouter: sSelf)
            let presenter = EnterEmailForgotPasswordPresenter(view: vc,
                                                              newPasswordRouter: sSelf,
                                                              networkManager: sSelf.networkManager)
            vc.presenter = presenter
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    
    func showEnterEmailNewUserScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = NewPasswordEnterEmailViewController(newPasswordRouter: sSelf)
            let presenter = EnterEmailNewUserPresenter(view: vc,
                                                       newPasswordRouter: sSelf,
                                                       networkManager: sSelf.networkManager)
            vc.presenter = presenter
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showForgotPasswordVerificationCodeScreen(email: String) {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = VerificationCodeViewController()
            
            let presenter = VerificationCodeForgotPasswordPresenter(view: vc,
                                                                    newPasswordRouter: sSelf,
                                                                    networkManager: sSelf.networkManager,
                                                                    email: email)
            vc.presenter = presenter
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showNewUserVerificationCodeScreen(email: String) {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = VerificationCodeViewController()
            
            let presenter = VerificationCodeNewUserPresenter(view: vc,
                                                             newPasswordRouter: sSelf,
                                                             networkManager: sSelf.networkManager,
                                                             email: email)
            vc.presenter = presenter
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showEmailVerifiedSuccessfullyScreen(email: String, verificationCode: String, passwordAction: PasswordAction) {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = SuccessfullViewController()
            let presenter = EmailVerifiedSuccessfullyPresenter(view: vc,
                                                               newPasswordRouter: sSelf,
                                                               networkManager: sSelf.networkManager,
                                                               email: email,
                                                               verificationCode: verificationCode, passwordAction: passwordAction)
            vc.presenter = presenter
            vc.hidesBottomBarWhenPushed = true
            
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showNewPasswordInputScreen(email: String, verificationCode: String, passwordAction: PasswordAction) {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = CreateNewPasswordViewController(newPasswordRouter: sSelf,
                                                     networkManager: sSelf.networkManager,
                                                     email: email,
                                                     verificationCode: verificationCode,
                                                     passwordAction: passwordAction)
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showPasswordResetSuccessfullyScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = SuccessfullViewController()
            let presenter = PasswordResetSuccessfullyPresenter(view: vc,
                                                               newPasswordRouter: sSelf,
                                                               networkManager: sSelf.networkManager)
            vc.presenter = presenter
            vc.hidesBottomBarWhenPushed = true
            
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showPasswordCreatedSuccessfullyScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = SuccessfullViewController()
            let presenter = PasswordCreatedSuccessfullyPresenter(view: vc,
                                                                 newPasswordRouter: sSelf,
                                                                 networkManager: sSelf.networkManager)
            vc.presenter = presenter
            vc.hidesBottomBarWhenPushed = true
            
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func backToLoginScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }
    }
    
}
