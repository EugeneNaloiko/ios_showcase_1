//
//  UpdateUserProgram.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: GetUserProgram
    func updateUserProgram(program: UserProgramModel, completion: @escaping (UserProgramModel?, NetworkResponseError?) -> Void) {
        func performRequest() {
            let endpoint: EndPoint = .updateUserProgram(model: program)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: UserProgramModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else if let responseModel = responseModel {
                        for (index, userProgram) in (StorageDataManager.shared.userPrograms ?? []).enumerated() {
                            if userProgram.programSku == responseModel.programSku {
                                StorageDataManager.shared.userPrograms?[index] = responseModel
                            }
                        }
                        completion(responseModel, responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
}
