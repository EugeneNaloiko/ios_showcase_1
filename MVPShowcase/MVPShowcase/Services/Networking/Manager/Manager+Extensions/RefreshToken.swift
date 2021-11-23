//
//  RefreshToken.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: Refresh Token
    func refreshToken(completion: @escaping (_ error: NetworkResponseError?) -> Void) {
        
        let endpoint: EndPoint = .refreshToken
        
        router.request(endpoint, completion: { [weak self] data, response, error in
            guard let sSelf = self else { return }
            
            sSelf.responseDataProcessingGeneric(data: data,
                                                response: response,
                                                error: error,
                                                isShouldRefreshToken: false,
                                                completion: { (responseModel: AuthenticationModel?, responseError, _) in
                                                    if let tokenModel = responseModel {
                                                        StorageDataManager.shared.authDataModel?.authenticationToken = "Bearer \(tokenModel.authenticationToken)"
                                                        completion(nil)
                                                    } else {
                                                        completion(responseError)
                                                    }
                                                })
        })
    }
    
}
