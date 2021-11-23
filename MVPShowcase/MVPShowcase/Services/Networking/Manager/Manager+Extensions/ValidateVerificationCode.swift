//
//  ValidateVerificationCode.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: ValidateVerificationCode
    func validateVerificationCode(email: String, verificationCode: String, completion: ((_ isValidated: Bool) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .validateVerificationCode(email: email, verificationCode: verificationCode)
            
            router.request(endpoint, completion: { data, response, error in
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    if responseString == "false" {
                        completion?(false)
                    } else if responseString == "true" {
                        completion?(true)
                    }
                } else {
                    completion?(false)
                }
            })
        }
        
        performRequest()
    }
    
}
