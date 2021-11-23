//
//  AuthenticationLogin.swift
//  NetworkLayer
//
//  Created by Eugene on
//

import Foundation

extension NetworkManager {
    
    // MARK: Authentication
    func authLogin(email: String, password: String, completion: @escaping (_ authenticationModel: AuthenticationModel?, _ error: NetworkResponseError?) -> Void) {
        
        func performRequest() {
            let endpoint: EndPoint = .authLogin(email: email, password: password)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: false) { (responseModel: AuthenticationModel?, responseError, _)  in
                    completion(responseModel, responseError)
                }
            })
        }
        
        performRequest()
    }
    
}
