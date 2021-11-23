//
//  UpdateCurrentFitnessLevelPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class UpdateCurrentFitnessLevelPresenter: BasePresenter, CurrentFitnessLevelPresenterProtocol {
    
    weak var view: CurrentFitnessLevelVCProtocol!
    weak var profileRouter: ProfileRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    private var userDataModel: UserInfoModel
    let isNavigationBarTransparent: Bool = false
    let navigationTitle: String? = L.string("FITNESS_LEVEL")
    let titleText = L.string("WHATS_YOUR_CURRENT_FITNESS_LEVEL")
    let descriptionText = L.string("WE_WILL_CUSTOMIZE_YOUR_EXPERIENCE_BASED_ON_YOUR_SELECTIONS")

    let nextButtonTitle = L.string("UPDATE_STRING")
    let isLogoHidden = true
    
    init(view: CurrentFitnessLevelVCProtocol, profileRouter: ProfileRouterProtocol, networkManager: NetworkManagerProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
        super.init()
        self.view = view
        self.profileRouter = profileRouter
        self.networkManager = networkManager
    }
    
    func getCurrentFitnessLevel() -> FitnessLevel? {
        return self.userDataModel.profile?.currentFitnessLevel
    }
    
    func setSelectedFitnessLevel(fitnessLevel: FitnessLevel) {
        self.userDataModel.profile?.currentFitnessLevel = fitnessLevel
    }
    
    func btnNextTapped() {
        self.view.startIndicator()
        var userProfileToUpdate = UserProfileModel()
        userProfileToUpdate.currentFitnessLevel = userDataModel.profile?.currentFitnessLevel
        networkManager.updateUserProfile(profile: userProfileToUpdate, completion: { [weak self] responseModel, error in
            GlobalUpdateService.shared.getDashboardInfo(completion: nil)
            self?.networkManager.getUserInfo(completion: { [weak self] _, _ in
                NotificationCenter.default.post(name: .userInfoUpdated, object: self)
                self?.view.stopIndicator()
                self?.view.popVC()
            })
        })
    }

}
