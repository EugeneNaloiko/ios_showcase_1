//
//  GetLeaderboard.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension NetworkManager {
    
    struct LastCalculatedPositionModel {
        var totalPoints: Int
        var position: Int
    }

    // MARK: GetLeaderboard
    func getLeaderboard(completion: ((_ leaderboardModel: [LeaderboardModel]?, _ error: NetworkResponseError?) -> Void)?) {
        
        func performRequest() {
            let endpoint: EndPoint = .getLeaderboard
            
            router.request(endpoint, completion: { [weak self] data, response, error in
                guard let sSelf = self else { return }
                sSelf.responseDataProcessingGeneric(data: data, response: response, error: error, isShouldRefreshToken: true) { [weak self] (responseModel: [LeaderboardModel]?, responseError, isShouldRepeatRequest)  in
                    guard let sSelf = self else { return }
                    guard !isShouldRepeatRequest else { performRequest(); return }
                    if let _ = responseError {
                        UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: performRequest)
                    } else {
                        if let responseModel = responseModel {
                            sSelf.getUsersProfileImagesFromServer(leaderboard: responseModel,
                                                            completion: { updatedLeaderboard in
                                                                let sortedDataModelWithUsersPosition = sSelf.setupPositionForUser(leaderboard: updatedLeaderboard)
                                                                completion?(sortedDataModelWithUsersPosition, responseError)
                            })
                        } else {
                            completion?(nil, nil)
                        }
                    }
                }
            })
        }
        performRequest()
    }
    
    private func setupPositionForUser(leaderboard: [LeaderboardModel]?) -> [LeaderboardModel] {
        
        let sortedDataModel = (leaderboard ?? []).sorted(by: {$0.totalPoints ?? 0 > $1.totalPoints ?? 0})
        
        var lastCalculatedPosition = LastCalculatedPositionModel(totalPoints: 0, position: 0)
        
        var newLeaderboard: [LeaderboardModel] = []
        
        for (index, item) in sortedDataModel.enumerated() {
            var item = item
            
            switch index {
            case 0:
                lastCalculatedPosition.totalPoints = item.totalPoints ?? 0
                lastCalculatedPosition.position = 1
                item.position = 1
                newLeaderboard.append(item)
            default:
                if lastCalculatedPosition.totalPoints == item.totalPoints {
                    item.position = lastCalculatedPosition.position
                    newLeaderboard.append(item)
                } else {
                    lastCalculatedPosition.totalPoints = item.totalPoints ?? 0
                    lastCalculatedPosition.position = index + 1
                    item.position = lastCalculatedPosition.position
                    newLeaderboard.append(item)
                }
            }
        }
        
        return newLeaderboard
    }
    
    private func getUsersProfileImagesFromServer(leaderboard: [LeaderboardModel], completion: ((_ updatedLeaderboard: [LeaderboardModel]) -> Void)?) {
        var updatedLeaderBoard: [LeaderboardModel] = []
        
        var requestCount = 0
        var responseCount = 0 {
            didSet {
                if requestCount == responseCount {
                    completion?(updatedLeaderBoard)
                }
            }
        }
        
        for item in leaderboard {
            var item = item
            requestCount += 1
            if let imageId = item.profileImageId {
                self.getProfileImage(imageId: imageId, completion: { imageData, _ in
                    item.profileImageData = imageData
                    updatedLeaderBoard.append(item)
                    responseCount += 1
                })
            } else {
                updatedLeaderBoard.append(item)
                responseCount += 1
            }
        }
    }
    
}
