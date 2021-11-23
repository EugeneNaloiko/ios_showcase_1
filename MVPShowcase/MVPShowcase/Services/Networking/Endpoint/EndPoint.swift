//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Eugene
//

import Foundation

enum NetworkEnvironment: String, CaseIterable {
    case PROD
    case STAGING
    case DEV
}

enum EndPoint {
    case authLogin(email: String, password: String)
    case refreshToken
    case authLogout
    case getUserInfo
    case updateUserProfile(profile: UserProfileModel)
    case getDashboardInfo
    case enroll(programSku: String, waveId: String, localDate: String)
    case disenrol(programSku: String)
    case getAllVideos
    case getUserPrograms
    case updateUserProgram(model: UserProgramModel)
    case pauseProgram(userProgram: UserProgramModel)
    case unPauseProgram(programId: String, reIndexDate: String)
    case getAllWorkoutExerciseProgress
    case completeWorkout(bodyDataModel: CompleteWorkoutBodyDataModel)
    case incompleteWorkout(userWorkoutHistoryId: String)
    case getBadgeTypes
    case getMyBadges
    case updateMyBadge(badgeId: String, hasUserBeenNotified: Bool)
    case getLeaderboard
    case uploadImage(data: Data)
    case getProfileImage(imageId: String)
    case updatePassword(newPassword: String)
    case setPassword(newPassword: String, email: String, token: String)
    case forgotPasswordSendVerificationCode(email: String)
    case validateVerificationCode(email: String, verificationCode: String)
    case skipToday
}

extension EndPoint: EndPointType {    
    var baseURL : URL {
        switch self {
        case .getAllVideos:
            guard let url = URL(string: Constants.BaseURL.museBaseURL) else { fatalError("museBaseURL could not be configured.")}
            return url
        default:
            guard let url = URL(string: Constants.BaseURL.environmentBaseURL) else { fatalError("baseURL could not be configured.")}
            return url
        }
    }
    
    var path: String {
        switch self {
        case .authLogin:
            return Constants.PathURL.authLogin()
        case .refreshToken:
            return Constants.PathURL.refreshToken()
        case .authLogout:
            return Constants.PathURL.authLogout()
        case .getUserInfo:
            return Constants.PathURL.getUserInfo()
        case .updateUserProfile:
            return Constants.PathURL.getUserInfo()
        case .getDashboardInfo:
            return Constants.PathURL.getDashboardInfo()
        case .enroll:
            return Constants.PathURL.enrolPathUrl()
        case .disenrol:
            return Constants.PathURL.disenrolPathUrl()
        case .getAllVideos:
            return Constants.PathURL.getAllVideosPathUrl()
        case .getUserPrograms:
            return Constants.PathURL.getUserProgram()
        case .updateUserProgram(let model):
            guard let id = model.id else {
                assertionFailure("User Program should have an id at this point")
                return ""
            }
            return Constants.PathURL.updateUserProgram(programId: id)
        case .pauseProgram(let userProgram):
            return Constants.PathURL.pauseProgram(userProgram: userProgram)
        case .unPauseProgram(let programId, _):
            return Constants.PathURL.unPauseProgram(programId: programId)
        case .getAllWorkoutExerciseProgress:
            return Constants.PathURL.getAllWorkoutExerciseProgressPath()
        case .completeWorkout:
            return Constants.PathURL.completeWorkoutPath()
        case .incompleteWorkout(let userWorkoutHistoryId):
            return Constants.PathURL.incompleteWorkoutPath(userWorkoutHistoryId: userWorkoutHistoryId)
        case .getBadgeTypes:
            return Constants.PathURL.getBadgeTypesPath()
        case .getMyBadges:
            return Constants.PathURL.getMyBadgesPath()
        case .updateMyBadge(let badgeId, _):
            return Constants.PathURL.updateMyBadgePath(badgeId: badgeId)
        case .getLeaderboard:
            return Constants.PathURL.getLeaderboardPath()
        case .getProfileImage(let imageId):
            return Constants.PathURL.getProfileImage(imageId: imageId)
        case .uploadImage:
            return Constants.PathURL.uploadImagePath()
        case .updatePassword:
            return Constants.PathURL.updatePasswordPath()
        case .setPassword:
            return Constants.PathURL.setPasswordPath()
        case .forgotPasswordSendVerificationCode:
            return Constants.PathURL.forgotPasswordSendVerificationCodePath()
        case .validateVerificationCode:
            return Constants.PathURL.validateVerificationCodePath()
        case .skipToday:
            return Constants.PathURL.skipTodayPath()
            
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .authLogin,
             .refreshToken,
             .authLogout,
             .enroll,
             .disenrol,
             .pauseProgram,
             .unPauseProgram,
             .completeWorkout,
             .incompleteWorkout,
             .uploadImage,
             .updateMyBadge,
             .forgotPasswordSendVerificationCode,
             .validateVerificationCode,
             .setPassword:
            return .post
        case .getUserInfo,
             .getDashboardInfo,
             .getAllVideos,
             .getUserPrograms,
             .getAllWorkoutExerciseProgress,
             .getBadgeTypes,
             .getMyBadges,
             .getLeaderboard,
             .getProfileImage:
            return .get
        case .updateUserProfile,
             .updateUserProgram,
             .updatePassword,
             .skipToday:
            return .put
        }
    }
    
}
