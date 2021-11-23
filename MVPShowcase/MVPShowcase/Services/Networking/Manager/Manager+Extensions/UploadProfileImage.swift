//
//  UploadProfileImage.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: UploadProfileImage
    
    func uploadImage(imageData: Data, completion: ((_ responseDataModel: UploadImageResponseModel?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .uploadImage(data: imageData)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: UploadImageResponseModel?, responseError, isShouldRepeatRequest)  in
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
