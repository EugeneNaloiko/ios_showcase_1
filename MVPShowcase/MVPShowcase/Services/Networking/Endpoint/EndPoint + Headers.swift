//
//  EndPoint + Headers.swift
//  NetworkLayer
//
//  Created by Eugene
//

import Foundation

extension EndPoint {
    
    var headers: HTTPHeaders? {
        switch self {
        case .authLogin,
             .refreshToken,
             .setPassword,
             .forgotPasswordSendVerificationCode,
             .validateVerificationCode:
            return nil
        case .authLogout,
             .getUserInfo,
             .updateUserProfile,
             .getDashboardInfo,
             .enroll,
             .disenrol,
             .getUserPrograms,
             .updateUserProgram,
             .pauseProgram,
             .unPauseProgram,
             .getAllWorkoutExerciseProgress,
             .completeWorkout,
             .incompleteWorkout,
             .getBadgeTypes,
             .getMyBadges,
             .getLeaderboard,
             .getProfileImage,
             .updateMyBadge,
             .updatePassword,
             .skipToday:
            return [Constants.Headers.authorization: StorageDataManager.shared.authDataModel?.authenticationToken ?? "",
                    Constants.Headers.contentType: Constants.Headers.applicationJson,
                    Constants.Headers.userLocalDate: Date().toDateIgnoreAnyTimeZone()!.toString(dateFormat: "YYYY-MM-dd")
            ]
        case .getAllVideos:
            return ["Key": Constants.Headers.museKey]
        case .uploadImage:
            return [Constants.Headers.authorization: StorageDataManager.shared.authDataModel?.authenticationToken ?? ""]
        }
    }
    
}
