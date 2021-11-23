//
//  UpdateUserProfile.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: UpdateUserProfile
    func updateUserProfile(profile: UserProfileModel, completion: ((_ authenticationModel: UserInfoModel?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .updateUserProfile(profile: profile)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: UserInfoModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        StorageDataManager.shared.userDataModel = responseModel
                        completion?(responseModel, responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
    
}
