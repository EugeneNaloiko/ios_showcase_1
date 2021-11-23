//
//  AppDelegate.swift
//  MVPShowcase
//
//  Created by Eugene Naloiko on 22.11.2021.
//

import UIKit
import netfox
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    lazy var appRouter: AppRouterProtocol = AppRouter(window: self.window)
    /// Set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NFX.sharedInstance().start()
        self.appRouter.appStart()
        self.setupReachability()
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    
    private func setupReachability() {
        do {
            try Network.reachability = Reachability()
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(checkNetworkStatus),
                         name: .flagsChanged,
                         object: nil)
        self.checkNetworkStatus()
    }
    
    @objc func checkNetworkStatus() {
        print("Status:", Network.reachability.status)
        switch Network.reachability.status {
        case .unreachable:
            DispatchQueue.main.async {
                self.appRouter.displayDeviceOfflineBanner()
            }
        case .wifi, .wwan:
            DispatchQueue.main.async {
                self.appRouter.hideDeviceOfflineBanner()
            }
        }
    }
}
