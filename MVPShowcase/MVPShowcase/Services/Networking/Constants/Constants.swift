//
//  Constants.swift
//  NKConstants
//
//  Created by Eugene on 02.11.2019.
//  Copyright © 2019 Tarmeez Co. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: Network Layer Constants - Base URL
    struct BaseURL {
        
        static var environmentBaseURL : String {
            switch StorageDataManager.shared.environment {
            case .PROD:
                return "http://prod.com"
            case .STAGING:
                return "http://staging.com"
            case .DEV:
                return "http://dev.com"
            }
        }
        
        static var museBaseURL : String {
            return "https://muse.ai"
        }
        
    }
    
    // MARK: Network Layer Constants - Path URL
    struct PathURL {
        
        static func authLogin() -> String {
            return "/login"
        }
        
        static func refreshToken() -> String {
            return "/refresh"
        }
        
        static func authLogout() -> String {
            return "/logout"
        }
        
        static func getUserInfo() -> String {
            return "/me"
        }
        
        static func getDashboardInfo() -> String {
            return "/dashboard"
        }
        
        static func enrolPathUrl() -> String {
            return "/enroll"
        }
        
        static func disenrolPathUrl() -> String {
            return "/disenroll"
        }
        
        static func getAllVideosPathUrl() -> String {
            return "/api/files/videos"
        }
        
        static func getUserProgram() -> String {
            return "/userProgram"
        }
        
        static func updateUserProgram(programId: String) -> String {
            return "/userProgram/\(programId)"
        }
        
        static func pauseProgram(userProgram: UserProgramModel) -> String {
            return "/userProgram/\(userProgram.id ?? "")/pause"
        }
        
        static func unPauseProgram(programId: String) -> String {
            return "/userProgram/\(programId)/unpause"
        }
        
        static func getAllWorkoutExerciseProgressPath() -> String {
            return "/workout"
        }
        
        static func completeWorkoutPath() -> String {
            return "/workout/complete"
        }
        
        static func incompleteWorkoutPath(userWorkoutHistoryId: String) -> String {
            return "/workout/\(userWorkoutHistoryId)/incomplete"
        }
        
        static func uploadProfileImagePath() -> String {
            return "/me/profileImage"
        }
        
        static func getBadgeTypesPath() -> String {
            return "/badge/types"
        }
        
        static func getMyBadgesPath() -> String {
            return "/badge"
        }
        
        static func getLeaderboardPath() -> String {
            return "/leaderboard"
        }
        
        static func getProfileImage(imageId: String) -> String {
            return "/profileImage/\(imageId)"
        }
        
        static func uploadImagePath() -> String {
            return "/me/profileImage"
        }
        
        static func updateMyBadgePath(badgeId: String) -> String {
            return "/badge/\(badgeId)"
        }
        
        static func updatePasswordPath() -> String {
            return "/me/password"
        }
        
        static func setPasswordPath() -> String {
            return "/setPassword"
        }

        static func forgotPasswordSendVerificationCodePath() -> String {
            return "/forgotPassword"
        }
        
        static func validateVerificationCodePath() -> String {
            return "/validateToken"
        }
        
        static func skipTodayPath() -> String {
            return "/skip"
        }
        
    }
    
    // MARK: Network Layer Constants - Parameters name
    struct Parameters {
    }
    
    // MARK: Network Layer Constants - Parameters value
    struct ParametersValue {
    }
    
    // MARK: Network Layer Constants - Headers
    struct Headers {
        public static let authorization = "Authorization"
        public static let bearer = "Bearer"
        public static let contentType = "Content-Type"
        
        /// This header is used for streaks calculation
        public static let userLocalDate = "X-User-Local-Date"
        public static let applicationJson = "application/json"
        public static let museKey = "blablakey"
    }
}
