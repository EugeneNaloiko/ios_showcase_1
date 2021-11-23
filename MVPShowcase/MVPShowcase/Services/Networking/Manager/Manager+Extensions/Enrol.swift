//
//  Enrol.swift
//
//  Created by Eugene Naloiko on 27.07.2021.
//

import Foundation

extension NetworkManager {
    
    // MARK: Enrol
    func enrol(programSku: String, waveId: String, localDate: String, completion: @escaping (_ authenticationModel: UserProgramModel?, _ error: NetworkResponseError?) -> Void) {
        
        func performRequest() {
            let endpoint: EndPoint = .enroll(programSku: programSku, waveId: waveId, localDate: localDate)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: UserProgramModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        GlobalUpdateService.shared.getDashboardInfo(completion: nil)
                        GlobalUpdateService.shared.getUserPrograms(completion: nil)
                        completion(responseModel, responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
    
}
