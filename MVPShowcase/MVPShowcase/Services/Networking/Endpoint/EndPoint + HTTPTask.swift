//
//  EndPoint + HTTPTask.swift
//  NetworkLayer
//
//  Created by Eugene
//

import Foundation

extension EndPoint {
    
    var task: HTTPTask {
        switch self {
        case .authLogin(let email, let password):
            let bodyParameters: HTTPParameters = ["email": email,
                                                  "password": password]
            return .requestParameters(bodyParameters: bodyParameters,
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        case .refreshToken:
            let bodyParameters: HTTPParameters = ["refreshToken": StorageDataManager.shared.authDataModel?.refreshToken ?? ""]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .authLogout:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .getUserInfo:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .updateUserProfile(let profile):
            let bodyParameters: HTTPParameters = ["profile": profile.dictionary]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .getDashboardInfo, .getUserPrograms:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .enroll(let programSku, let waveId, let localDate):
            let bodyParameters: HTTPParameters = ["programSku": programSku,
                                                  "selectedWave": waveId,
                                                  "reIndexDate": localDate,
                                                  "localDate": localDate]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .disenrol(let programSku):
            let bodyParameters: HTTPParameters = ["programSku": programSku]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .getAllVideos:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .updateUserProgram(let model):
            let bodyParameters: HTTPParameters = model.dictionary
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .pauseProgram(let userProgram):
            let bodyParameters: HTTPParameters = userProgram.dictionary
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .unPauseProgram(_, let reIndexDate):
            let bodyParameters: HTTPParameters = ["reIndexDate": reIndexDate]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .getAllWorkoutExerciseProgress:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .completeWorkout(let bodyDataModel):
            let bodyParameters: HTTPParameters = bodyDataModel.dictionary
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .incompleteWorkout:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .getBadgeTypes, .getMyBadges:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .getLeaderboard:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .getProfileImage:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .uploadImage(let data):
            return .multipartRequest(data: data, additionHeaders: self.headers)
        case .updateMyBadge(_, let hasUserBeenNotified):
            let bodyParameters: HTTPParameters = ["hasUserBeenNotified": hasUserBeenNotified]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .updatePassword(let newPassword):
            let bodyParameters: HTTPParameters = ["profile": ["password": newPassword]]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .setPassword(let newPassword, let email, let token):
            let bodyParameters: HTTPParameters = ["email": email, "token": token, "newPassword": newPassword]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        case .forgotPasswordSendVerificationCode(let email):
            let bodyParameters: HTTPParameters = ["email": email]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: nil)
        case .validateVerificationCode(let email, let verificationCode):
            let bodyParameters: HTTPParameters = ["email": email, "token": verificationCode]
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .jsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: nil)
        case .skipToday:
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding(urlEncodingType: .none),
                                                urlParameters: nil,
                                                additionHeaders: self.headers)
        }
    }
    
}
