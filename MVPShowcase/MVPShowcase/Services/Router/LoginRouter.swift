//
//  LoginRouter.swift
//
//  Created by Eugene Naloiko
//

import UIKit

//MARK: - LoginRouter Delegate Protocol
protocol LoginRouterDelegateProtocol: AnyObject {
    func loginRouterDidFinish()
}

//MARK: - LoginRouterProtocol
protocol LoginRouterProtocol: RouterProtocol {
    var navigationController: BaseNavigationController! { get }
    var delegate: LoginRouterDelegateProtocol? { set get }
    
    func start(window: UIWindow?, networkManager: NetworkManagerProtocol)
    func showWelcomeBackScreen(userDataModel: UserInfoModel)
    func showChooseCountryScreen(userDataModel: UserInfoModel)
    func showMaleOrFemaleScreen(userDataModel: UserInfoModel)
    func popToMaleOrFemaleScreen(userDataModel: UserInfoModel)
    func showHowOldAreYouScreen(userDataModel: UserInfoModel)
    func showCurrentFitnessLevelScreen(userDataModel: UserInfoModel)
    func showConfirmDetailsScreen(userDataModel: UserInfoModel)
    func showAwesomeScreen(userDataModel: UserInfoModel)
    
    func showEnterEmailNewUserScreen()
    func showEnterEmailForgotPasswordScreen()
    
    func showNewUserVerificationCodeScreen(email: String)
    func showForgotPasswordVerificationCodeScreen(email: String)
    
    func loginRouterDidFinish()
}

//MARK: - LoginRouter
class LoginRouter: LoginRouterProtocol {
    var navigationController: BaseNavigationController!
    weak var delegate: LoginRouterDelegateProtocol?
    private var networkManager: NetworkManagerProtocol!
    
    private var newPasswordRouter: NewPasswordRouterProtocol!
    
    func start(window: UIWindow?, networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let loginVC = LoginViewController()
            let presenter = LoginViewControllerPresenter(view: loginVC, loginRouter: sSelf, networkManager: sSelf.networkManager)
            loginVC.presenter = presenter
            
            sSelf.navigationController = BaseNavigationController(rootViewController: loginVC)
            
            sSelf.newPasswordRouter = NewPasswordRouter(networkManager: networkManager, navigationController: sSelf.navigationController)
            
            window?.rootViewController = sSelf.navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    func showWelcomeBackScreen(userDataModel: UserInfoModel) {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = WelcomeBackViewController(loginRouter: sSelf, userDataModel: userDataModel)
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showMaleOrFemaleScreen(userDataModel: UserInfoModel) {
        let vc = MaleOrFemaleViewController()
        let presenter = MaleOrFemalePresenter(view: vc,
                                              loginRouter: self,
                                              networkManager: self.networkManager,
                                              userDataModel: userDataModel)
        
        vc.presenter = presenter
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showChooseCountryScreen(userDataModel: UserInfoModel) {
        let vc = ChooseCountryViewController(loginRouter: self, userDataModel: userDataModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func popToMaleOrFemaleScreen(userDataModel: UserInfoModel) {
        for vc in self.navigationController.viewControllers {
            if vc is ChooseCountryViewController {
                (vc as! ChooseCountryViewController).userDataModel = userDataModel
                self.navigationController.popToViewController(vc, animated: true)
            }
        }
    }
    
    func showHowOldAreYouScreen(userDataModel: UserInfoModel) {
        let vc = HowOldAreYouViewController()
        let presenter = HowOldAreYouPresenter(view: vc,
                                              loginRouter: self,
                                              networkManager: self.networkManager,
                                              userDataModel: userDataModel)
        
        vc.presenter = presenter
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCurrentFitnessLevelScreen(userDataModel: UserInfoModel) {
        let vc = CurrentFitnessLevelViewController()
        let presenter = CurrentFitnessLevelPresenter(view: vc,
                                                     loginRouter: self,
                                                     networkManager: self.networkManager,
                                                     userDataModel: userDataModel)
        vc.presenter = presenter
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showConfirmDetailsScreen(userDataModel: UserInfoModel) {
        let vc = ConfirmDetailsViewController(loginRouter: self,
                                              networkManager: self.networkManager,
                                              userDataModel: userDataModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showAwesomeScreen(userDataModel: UserInfoModel) {
        let vc = AwesomeViewController(loginRouter: self, userDataModel: userDataModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showEnterEmailNewUserScreen() {
        self.newPasswordRouter.showEnterEmailNewUserScreen()
    }
    
    //RESET PASSWORD FLOW
    func showEnterEmailForgotPasswordScreen() {
        self.newPasswordRouter.showEnterEmailForgotPasswordScreen()
    }
    
    func loginRouterDidFinish() {
        self.delegate?.loginRouterDidFinish()
    }
    
    func showNewUserVerificationCodeScreen(email: String) {
        self.newPasswordRouter.showNewUserVerificationCodeScreen(email: email)
    }
    
    func showForgotPasswordVerificationCodeScreen(email: String) {
        self.newPasswordRouter.showForgotPasswordVerificationCodeScreen(email: email)
    }
}

