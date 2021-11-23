//
//  CompleteWorkout.swift
//
//  Created by Eugene Naloiko on 11.08.2021.
//

import Foundation

extension NetworkManager {
    
    // MARK: CompleteWorkout
    func completeWorkout(bodyDataModel: CompleteWorkoutBodyDataModel, completion: ((_ workoutExerciseProgressDataModel: WorkoutExerciseProgressDataModel?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .completeWorkout(bodyDataModel: bodyDataModel)
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: WorkoutExerciseProgressDataModel?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        GlobalUpdateService.shared.getDashboardInfo(completion: nil)
                        completion?(responseModel, responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
    
}
