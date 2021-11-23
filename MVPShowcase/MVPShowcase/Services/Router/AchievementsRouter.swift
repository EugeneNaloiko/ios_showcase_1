//
//  AchievementsRouter.swift
//
//  Created by Eugene Naloiko
//

import UIKit

//MARK: - AchievementsRouter Delegate Protocol
protocol AchievementsRouterDelegateProtocol: AnyObject {
    
}

//MARK: - ProfileRouter Protocol
protocol AchievementsRouterProtocol: RouterProtocol {
    var navigationController: BaseNavigationController! { get }
    var delegate: AchievementsRouterDelegateProtocol? { set get }
    
}

//MARK: - AchievementsRouter
class AchievementsRouter: AchievementsRouterProtocol {
    
    weak var navigationController: BaseNavigationController!
    weak var delegate: AchievementsRouterDelegateProtocol?
    weak var networkManager: NetworkManagerProtocol!
    
    init(networkManager: NetworkManagerProtocol, navigationController: BaseNavigationController) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
}
