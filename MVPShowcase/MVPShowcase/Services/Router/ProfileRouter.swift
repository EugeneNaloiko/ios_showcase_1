//
//  ProfileRouter.swift
//
//  Created by Eugene Naloiko
//

import UIKit

//MARK: - ProfileRouter Delegate Protocol
protocol ProfileRouterDelegateProtocol: AnyObject {
    
}

//MARK: - ProfileRouter Protocol
protocol ProfileRouterProtocol: RouterProtocol {
    var navigationController: ProfileNavigationController! { get }
    var delegate: ProfileRouterDelegateProtocol? { set get }
    
    func showPersonalDetailsScreen(profileImage: UIImage?)
    
    func showUpdateDateOfBirthScreen(userDataModel: UserInfoModel)
    func showUpdateMaleOrFemaleScreen(userDataModel: UserInfoModel)
    func showUpdateCurrentFitnessLevelScreen(userDataModel: UserInfoModel)
    func showUpdateYourFullNameScreen(userDataModel: UserInfoModel)
    func showProgramOverviewViewController(selectedProgram: ProgramDataModel)
    
    func showUpdatePasswordScreen()
    func showPasswordUpdatedSuccessfullScreen()
}

//MARK: - ProfileRouter
class ProfileRouter: ProfileRouterProtocol {
    
    weak var navigationController: ProfileNavigationController!
    weak var delegate: ProfileRouterDelegateProtocol?
    weak var networkManager: NetworkManagerProtocol!
    var programsRouter: ProgramsRouterProtocol!
    
    init(networkManager: NetworkManagerProtocol, navigationController: ProfileNavigationController) {
        self.navigationController = navigationController
        self.networkManager = networkManager
        
        self.programsRouter = ProgramsRouter(networkManager: networkManager, navigationController: navigationController)
    }
    
    
    func showPersonalDetailsScreen(profileImage: UIImage?) {
        let vc = PersonalDetailsViewController()
        let presenter = PersonalDetailsPresenter(profileRouter: self,
                                                 view: vc,
                                                 networkManager: self.networkManager,
                                                 profileImage: profileImage)
        vc.presenter = presenter
        vc.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showUpdateDateOfBirthScreen(userDataModel: UserInfoModel) {
        let vc = HowOldAreYouViewController()
        let presenter = UpdateDateOfBirthPresenter(view: vc,
                                                   profileRouter: self,
                                                   networkManager: self.networkManager,
                                                   userDataModel: userDataModel)
        vc.presenter = presenter
        vc.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showUpdateMaleOrFemaleScreen(userDataModel: UserInfoModel) {
        let vc = MaleOrFemaleViewController()
        let presenter = UpdateMaleOrFemalePresenter(view: vc,
                                                    profileRouter: self,
                                                    networkManager: self.networkManager,
                                                    userDataModel: userDataModel)
        vc.presenter = presenter
        vc.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showUpdateCurrentFitnessLevelScreen(userDataModel: UserInfoModel) {
        let vc = CurrentFitnessLevelViewController()
        let presenter = UpdateCurrentFitnessLevelPresenter(view: vc,
                                                           profileRouter: self,
                                                           networkManager: self.networkManager,
                                                           userDataModel: userDataModel)
        vc.presenter = presenter
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showUpdateYourFullNameScreen(userDataModel: UserInfoModel) {
        let vc = UpdateYourFullNameViewController()
        let presenter = UpdateYourFullNamePresenter(view: vc,
                                                    profileRouter: self,
                                                    networkManager: self.networkManager,
                                                    userDataModel: userDataModel)
        
        vc.presenter = presenter
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showUpdatePasswordScreen() {
        let vc = UpdatePasswordViewController()
        let presenter = UpdatePasswordFromProfilePresenter(view: vc,
                                                           profileRouter: self,
                                                           networkManager: self.networkManager)
        
        vc.presenter = presenter
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showPasswordUpdatedSuccessfullScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = SuccessfullViewController()
            let presenter = SuccessfullyPasswordUpdatedPresenter(view: vc,
                                                                 profileRouter: sSelf,
                                                                 networkManager: sSelf.networkManager)
            vc.presenter = presenter
            vc.hidesBottomBarWhenPushed = true
            
            sSelf.navigationController.pushViewController(vc, animated: true)
        }

    }
    
    func showProgramOverviewViewController(selectedProgram: ProgramDataModel) {
        self.programsRouter.showProgramOverviewViewController(selectedProgram: selectedProgram)
    }
    
}
