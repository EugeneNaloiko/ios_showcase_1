//
//  GetAllVideosFromMuse.swift
//
//  Created by Eugene Naloiko on 29.07.2021.
//

import Foundation

extension NetworkManager {
    
    // MARK: GetAllVideosFromMuse
    func getAllVideosFromMuse(completion: @escaping (_ allMuseVideosModel: [AllMuseVideosModel]?, _ error: NetworkResponseError?) -> Void) {
        
        func performRequest() {
            let endpoint: EndPoint = .getAllVideos
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: false) { (responseModel: [AllMuseVideosModel]?, responseError, _)  in
                    completion(responseModel, responseError)
                }
            })
        }
        
        performRequest()
    }
    
}
