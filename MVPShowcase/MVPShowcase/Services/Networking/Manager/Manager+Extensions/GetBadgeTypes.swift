//
//  GetBadgeTypes.swift
//
//  Created by Eugene Naloiko on 24.08.2021.
//

import Foundation

extension NetworkManager {
    
    // MARK: GetBadgeTypes
    func getBadgeTypes(completion: ((_ badgeTypesModel: [BadgeTypeModel]?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .getBadgeTypes
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: [BadgeTypeModel]?, responseError, isShouldRepeatRequest)  in
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
