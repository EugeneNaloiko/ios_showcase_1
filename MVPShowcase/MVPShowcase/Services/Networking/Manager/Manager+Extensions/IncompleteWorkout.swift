//
//  IncompleteWorkout.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    // MARK: IncompleteWorkout
    func incompleteWorkout(userWorkoutHistoryId: String, completion: (( _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .incompleteWorkout(userWorkoutHistoryId: userWorkoutHistoryId)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: EmptyModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        GlobalUpdateService.shared.getDashboardInfo(completion: nil)
                        completion?(responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
    
}
