//
//  GlobalUpdateService.swift
//
//  Created by Eugene Naloiko on 03.09.2021.
//

import Foundation

class GlobalUpdateService {
    
    static var shared = GlobalUpdateService()
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    func getDashboardInfo(completion: (() -> Void)?) {
        networkManager.getDashboardInfo(completion: { dashboardinfo, error in
            NotificationCenter.default.post(name: .dashboardInfoUpdated, object: nil)
            completion?()
        })
    }
    
    func getUserPrograms(completion: (() -> Void)?) {
        networkManager.getUserPrograms(completion: { userPrograms, error in
            NotificationCenter.default.post(name: .userProgramsUpdated, object: nil)
            completion?()
        })
    }
    
}
