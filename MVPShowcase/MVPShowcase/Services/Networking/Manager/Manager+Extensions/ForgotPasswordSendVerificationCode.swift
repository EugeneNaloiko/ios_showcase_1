//
//  ForgotPasswordSendVerificationCode.swift
//
//  Created by Eugene Naloiko on 09.09.2021.
//

import Foundation

extension NetworkManager {
    
    // MARK: ForgotPasswordSendVerificationCode
    func forgotPasswordSendVerificationCode(email: String, completion: ((_ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .forgotPasswordSendVerificationCode(email: email)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingWithoutMapping(data: data, response: response, error: error, completion: { (_, responseError) in
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        completion?(responseError)
                    }
                })
            })
        }
        
        performRequest()
    }
    
}
