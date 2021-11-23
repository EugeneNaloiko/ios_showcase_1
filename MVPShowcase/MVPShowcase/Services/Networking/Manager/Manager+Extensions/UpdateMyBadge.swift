//
//  UpdateMyBadge.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: UpdateMyBadge
    func updateMyBadge(badgeId: String, hasUserBeenNotified: Bool, completion: ((_ myBadgesModel: MyBadgesModel?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .updateMyBadge(badgeId: badgeId, hasUserBeenNotified: hasUserBeenNotified)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: MyBadgesModel?, responseError, isShouldRepeatRequest)  in
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
