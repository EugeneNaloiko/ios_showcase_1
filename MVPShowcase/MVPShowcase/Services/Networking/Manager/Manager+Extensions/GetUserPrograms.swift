//
//  GetUserProgram.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: GetUserProgram
    func getUserPrograms(completion: @escaping (_ userPrograms: [UserProgramModel]?, _ error: NetworkResponseError?) -> Void) {
        
        func performRequest() {
            let endpoint: EndPoint = .getUserPrograms
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: [UserProgramModel]?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        StorageDataManager.shared.userPrograms = responseModel
                        completion(responseModel, responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
}
