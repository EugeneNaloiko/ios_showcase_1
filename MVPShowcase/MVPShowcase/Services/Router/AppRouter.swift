//
//  AppDelegate.swift
//  MVPShowcase
//
//  Created by Eugene Naloiko on 28.05.2021.
//

import UIKit

protocol RouterProtocol: AnyObject {}

protocol AppRouterProtocol: RouterProtocol {
    var window: UIWindow? { get }
    
    func appStart()
    
    func switchToProfileTab()
    func switchToScheduleTab()
    
    func displayDeviceOfflineBanner()
    func hideDeviceOfflineBanner()
}

class AppRouter: AppRouterProtocol {
    var window: UIWindow?
    private var tabBarController: UITabBarController?
    
    private var networkManager: NetworkManagerProtocol!
    
    private var loginRouter: LoginRouterProtocol?
    
    private lazy var deviceOfflineBanner = DeviceOfflineView()
    
    init(window: UIWindow?) {
        self.window = window
        self.window?.backgroundColor = .tfWhite
        self.networkManager = NetworkManager()
        self.subscribeClosures()
    }
    
    private func subscribeClosures() {
        self.networkManager.performForceLogoutClosure = { [weak self] in
            guard let sSelf = self else { return }
            StorageDataManager.shared.cleanSavedDataForLogout()
            sSelf.displayLoginScreen()
        }
    }
    
    func appStart() {
        self.displayLoginScreen()
    }
    
    private func displayLoginScreen() {
        self.tabBarController = nil
        self.loginRouter = LoginRouter()
        self.loginRouter?.delegate = self
        self.loginRouter?.start(window: window, networkManager: self.networkManager)
    }
    
    func displayHomeScreen() {
        GlobalUpdateService.shared.getDashboardInfo(completion: {
            GlobalUpdateService.shared.getUserPrograms(completion: { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.window?.rootViewController?.dismiss(animated: false, completion: nil)
                    sSelf.tabBarController = MainTabBarController(appRouter: sSelf, networkManager: sSelf.networkManager)
                    sSelf.window?.rootViewController = sSelf.tabBarController
                    sSelf.window?.makeKeyAndVisible()
                }
            })
        })
    }
    
    func switchToProfileTab() {
        self.tabBarController?.selectedIndex = 4
    }
    
    func switchToScheduleTab() {
        self.tabBarController?.selectedIndex = 1
    }
    
    func displayDeviceOfflineBanner() {
        self.deviceOfflineBanner.setData(titleText: L.string("OOOPS"),
                                         descriptionText: L.string("IT_SEEMS_YOUR_DEVICE_IS_OFFLINE_PLEASE_CONNECT_TO_THE_INTERNET_AND_TRY_AGAIN"))
        self.window?.addSubview(self.deviceOfflineBanner)
        guard let keyWindow = self.window else { return }
        self.deviceOfflineBanner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.deviceOfflineBanner.heightAnchor.constraint(equalTo: keyWindow.heightAnchor),
            self.deviceOfflineBanner.widthAnchor.constraint(equalTo: keyWindow.widthAnchor),
            self.deviceOfflineBanner.topAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0)
        ])
    }
    
    func hideDeviceOfflineBanner() {
        self.deviceOfflineBanner.removeFromSuperview()
    }
    
}

//MARK: - LoginRouterDelegateProtocol
extension AppRouter: LoginRouterDelegateProtocol {
    func loginRouterDidFinish() {
        #if DEBUG
        print("loginRouterDidFinish: Login navigation did finished!")
        #endif
        self.loginRouter = nil
        self.displayHomeScreen()
    }
}

//MARK: - ProfileRouterDelegateProtocol
extension AppRouter: ProfileRouterDelegateProtocol {
    func logout() {
        DispatchQueue.main.async  { [weak self] in
            guard let sSelf = self else { return }
            sSelf.window?.rootViewController?.dismiss(animated: false, completion: nil)
            sSelf.displayLoginScreen()
        }
        
    }
}
