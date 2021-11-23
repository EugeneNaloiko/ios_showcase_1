//
//  GetUserInfo.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: GetUserInfo
    func getUserInfo(completion: @escaping (_ authenticationModel: UserInfoModel?, _ error: NetworkResponseError?) -> Void) {
        
        func performRequest() {
            let endpoint: EndPoint = .getUserInfo
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: UserInfoModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    StorageDataManager.shared.userDataModel = responseModel
                    completion(responseModel, responseError)
                }
            })
        }
        
        performRequest()
    }
    
}
