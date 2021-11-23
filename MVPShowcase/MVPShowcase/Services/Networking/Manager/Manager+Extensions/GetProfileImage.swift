//
//  GetProfileImage.swift
//
//  Created by Eugene Naloiko
//

import Foundation
import UIKit

extension NetworkManager {
    
    // MARK: GetProfileImage
    func getProfileImage(imageId: String, completion: ((_ imageData: Data?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .getProfileImage(imageId: imageId)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingWithoutMapping(data: data, response: response, error: error, completion: { data, error in
                    if let data = data {
                        completion?(data, nil)
                    } else {
                        completion?(nil, error)
                    }
                })
                
                
//                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: [LeaderboardModel]?, responseError, isShouldRepeatRequest)  in
//                    guard !isShouldRepeatRequest else { performRequest(); return }
////                    if let _ = responseError {
////                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
////                    } else {
//                    if let data = responseModel {
//
//                    }
//                        completion?(sortedDataModelWithUsersPosition, responseError)
////                    }
//                }
            })
        }
        performRequest()
    }
}
