//
//  SetPassword.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: Set Password
    func setPassword(newPassword: String, email: String, token: String, completion: ((NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .setPassword(newPassword: newPassword, email: email, token: token)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: EmptyModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        completion?(responseError)
                    }
                }
            })
        }
        
        performRequest()
        
    }
}
