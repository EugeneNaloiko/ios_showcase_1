//
//  SkipToday.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: SkipToday
    func skipToday(completion: ((_ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .skipToday
            
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

