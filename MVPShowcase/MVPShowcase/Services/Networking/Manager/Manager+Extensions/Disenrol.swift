//
//  Disenrol.swift
//
//  Created by Eugene Naloiko on 27.07.2021.
//

import Foundation

extension NetworkManager {
    
    // MARK: Disenrol
    func disenrol(programSku: String, completion: @escaping (_ error: NetworkResponseError?) -> Void) {
        
        let endpoint: EndPoint = .disenrol(programSku: programSku)
        router.request(endpoint, completion: { [weak self] data, response, error in
            guard let sSelf = self else { return }
            
            sSelf.responseDataProcessingWithoutMapping(data: data, response: response, error: error, completion: { (_, responseError)  in
                completion(responseError)
            })
        })
        
    }
}
