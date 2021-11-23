//
//  UnPauseProgram.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: UnPauseProgram
    func unPauseProgram(programId: String, reIndexDate: String, completion: @escaping (_ userProgramModel: UserProgramModel?, _ error: NetworkResponseError?) -> Void) {
        
        func performRequest() {
            let endpoint: EndPoint = .unPauseProgram(programId: programId, reIndexDate: reIndexDate)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: UserProgramModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        GlobalUpdateService.shared.getDashboardInfo(completion: nil)
                        completion(responseModel, responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
    
}
