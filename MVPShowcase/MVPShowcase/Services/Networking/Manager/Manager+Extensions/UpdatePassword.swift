//
//  UpdatePassword.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: Update Password
    func updatePassword(newPassword: String, completion: ((_ myBadgesModel: UserInfoModel?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .updatePassword(newPassword: newPassword)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: UserInfoModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        completion?(responseModel, responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
    
}
