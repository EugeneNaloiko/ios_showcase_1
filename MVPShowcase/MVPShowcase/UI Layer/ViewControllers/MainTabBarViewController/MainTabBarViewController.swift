//
//  MainTabBarViewController.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

class MainTabBarController: BaseTabBarController {
    
    weak var appRouter: AppRouterProtocol!
    
    weak var networkManager: NetworkManagerProtocol!
    
    init(appRouter: AppRouterProtocol, networkManager: NetworkManagerProtocol) {
        self.appRouter = appRouter
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.prepareUI()
        self.removeTopLine()
    }
    
    private func commonInit() {
        self.viewControllers = [self.getHomeScreenTabBarItem(),
                                self.getProfileScreenTabBarItem()]
    }
    
    private func prepareUI() {
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = UIColor.tfWhite
        self.view.backgroundColor = UIColor.tfWhite
        self.tabBar.tintColor = UIColor.tfOrangish
    }
    
    // MARK: Removing top line at the tabBar
    private func removeTopLine() {
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = UIColor.clear
        tabBar.standardAppearance = appearance
    }
    
}

extension MainTabBarController {
    private func getHomeScreenTabBarItem() -> BaseNavigationController {
        let homeVC = HomeViewController()
        let nav = BaseNavigationController(rootViewController: homeVC)
        let homeRouter = HomeRouter(networkManager: self.networkManager, navigationController: nav)
        let presenter = HomeViewControllerPesenter(view: homeVC,
                                                   appRouter: self.appRouter,
                                                   homeRouter: homeRouter,
                                                   networkManager: self.networkManager)
        homeVC.presenter = presenter
        
        nav.tabBarItem = UITabBarItem(title: L.string("HOME"),
                                      image: UIImage(named: "img_home_screen_unselected"),
                                      selectedImage: UIImage(named: "img_home_screen_selected"))
        return nav
    }
            
    private func getProfileScreenTabBarItem() -> UINavigationController {
        let vc = ProfileViewController()
        let nav = ProfileNavigationController(rootViewController: vc)
        
        let router = ProfileRouter(networkManager: self.networkManager,
                                   navigationController: nav)
        router.delegate = self.appRouter as? ProfileRouterDelegateProtocol
        
        let presenter = ProfilePresenter(profileRouter: router, view: vc, networkManager: self.networkManager)
        vc.presenter = presenter
        
        nav.tabBarItem = UITabBarItem(title: L.string("PROFILE"),
                                      image: UIImage(named: "img_profile_unselected"),
                                      selectedImage: UIImage(named: "img_profile_selected"))
        return nav
    }
    
}
