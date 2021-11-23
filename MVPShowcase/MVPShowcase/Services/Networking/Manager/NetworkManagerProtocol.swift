//
//  NetworkManagerProtocol.swift
//  NetworkLayer
//
//  Created by Eugene
//

import Foundation
import UIKit

protocol NetworkManagerProtocol: AnyObject {
    var performForceLogoutClosure: (() -> Void)? { get set }
    
    func authLogin(email: String, password: String, completion: @escaping (_ authenticationModel: AuthenticationModel?, _ error: NetworkResponseError?) -> Void)
    
    func authLogout(completion: ((_ error: NetworkResponseError?) -> Void)?)
    
    func getUserInfo(completion: @escaping (_ authenticationModel: UserInfoModel?, _ error: NetworkResponseError?) -> Void)
    
    func updateUserProfile(profile: UserProfileModel, completion: ((_ authenticationModel: UserInfoModel?, _ error: NetworkResponseError?) -> Void)?)
    
    func getDashboardInfo(completion: ((_ dashboardInfoModel: DashboardInfoModel?, _ error: NetworkResponseError?) -> Void)?)
    
    func enrol(programSku: String, waveId: String, localDate: String, completion: @escaping (_ authenticationModel: UserProgramModel?, _ error: NetworkResponseError?) -> Void)
    
    func disenrol(programSku: String, completion: @escaping (_ error: NetworkResponseError?) -> Void)
    
    func getAllVideosFromMuse(completion: @escaping (_ allMuseVideosModel: [AllMuseVideosModel]?, _ error: NetworkResponseError?) -> Void)
    
    func getUserPrograms(completion: @escaping (_ userPrograms: [UserProgramModel]?, _ error: NetworkResponseError?) -> Void)
    
    func updateUserProgram(program: UserProgramModel, completion: @escaping (_ authenticationModel: UserProgramModel?, _ error: NetworkResponseError?) -> Void)
    
    func pauseProgram(userProgram: UserProgramModel, completion: @escaping (_ userProgramModel: UserProgramModel?, _ error: NetworkResponseError?) -> Void)
    
    func unPauseProgram(programId: String, reIndexDate: String, completion: @escaping (_ userProgramModel: UserProgramModel?, _ error: NetworkResponseError?) -> Void)
    
    func getAllWorkoutExerciseProgress(completion: ((_ workoutExerciseProgressDataModel: [WorkoutExerciseProgressDataModel]?, _ error: NetworkResponseError?) -> Void)?)
    
    func completeWorkout(bodyDataModel: CompleteWorkoutBodyDataModel, completion: ((_ workoutExerciseProgressDataModel: WorkoutExerciseProgressDataModel?, _ error: NetworkResponseError?) -> Void)?)
    
    func incompleteWorkout(userWorkoutHistoryId: String, completion: ((_ error: NetworkResponseError?) -> Void)?)
    
    func uploadImage(imageData: Data, completion: ((_ responseDataModel: UploadImageResponseModel?, _ error: NetworkResponseError?) -> Void)?)
    
    func getBadgeTypes(completion: ((_ badgeTypesModel: [BadgeTypeModel]?, _ error: NetworkResponseError?) -> Void)?)
    
    func getMyBadges(completion: ((_ myBadgesModel: [MyBadgesModel]?, _ error: NetworkResponseError?) -> Void)?)
    
    func updateMyBadge(badgeId: String, hasUserBeenNotified: Bool, completion: ((_ myBadgesModel: MyBadgesModel?, _ error: NetworkResponseError?) -> Void)?)
    
    func getLeaderboard(completion: ((_ leaderboardModel: [LeaderboardModel]?, _ error: NetworkResponseError?) -> Void)?)
    
    func getProfileImage(imageId: String, completion: ((_ imageData: Data?, _ error: NetworkResponseError?) -> Void)?)
    
    func updatePassword(newPassword: String, completion: ((_ myBadgesModel: UserInfoModel?, _ error: NetworkResponseError?) -> Void)?)
    
    func setPassword(newPassword: String, email: String, token: String, completion: ((NetworkResponseError?) -> Void)?)
    
    func forgotPasswordSendVerificationCode(email: String, completion: ((_ error: NetworkResponseError?) -> Void)?)
    
    func validateVerificationCode(email: String, verificationCode: String, completion: ((_ isValidated: Bool) -> Void)?)
    
    func skipToday(completion: ((_ error: NetworkResponseError?) -> Void)?)
}
