//
//  LogOut.swift
//  NetworkLayer
//
//  Created by Eugene
//

import Foundation

extension NetworkManager {
    
    // MARK: LogOut
    func authLogout(completion: ((_ error: NetworkResponseError?) -> Void)?) {
        
        let endpoint: EndPoint = .authLogout
        router.request(endpoint, completion: { [weak self] data, response, error in
            guard let sSelf = self else { return }
            
            sSelf.responseDataProcessingWithoutMapping(data: data, response: response, error: error, completion: { (_, responseError) in
                completion?(responseError)
            })
        })
        
    }
}
