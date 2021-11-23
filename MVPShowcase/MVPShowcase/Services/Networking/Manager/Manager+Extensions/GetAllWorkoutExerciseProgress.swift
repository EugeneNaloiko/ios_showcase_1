//
//  GetAllWorkoutExerciseProgress.swift
//
//  Created by Eugene Naloiko on 11.08.2021.
//

import Foundation

extension NetworkManager {
        
    // MARK: GetAllWorkoutExerciseProgress
    func getAllWorkoutExerciseProgress(completion: ((_ workoutExerciseProgressDataModel: [WorkoutExerciseProgressDataModel]?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .getAllWorkoutExerciseProgress
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { (responseModel: [WorkoutExerciseProgressDataModel]?, responseError, isShouldRepeatRequest)  in
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        let reversedArray = Array((responseModel ?? []).reversed())
                        StorageDataManager.shared.allWorkoutExerciseProgress = reversedArray
                        completion?(reversedArray, responseError)
                    }
                }
            })
        }
        
        performRequest()
    }
}
