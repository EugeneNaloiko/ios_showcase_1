//
//  UpdateMaleOrFemalePresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class UpdateMaleOrFemalePresenter: BasePresenter, MaleOrFemalePresenterProtocol {
    
    weak var view: MaleOrFemaleVCProtocol!
    weak var profileRouter: ProfileRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    private var userDataModel: UserInfoModel
    let isNavigationBarTransparent: Bool = false
    let navigationTitle: String? = L.string("GENDER")
    let titleText = L.string("IDENTIFY_YOURSELF")
    let descriptionText = L.string("TO_PROVIDE_AN_OPTIONAL_EXPERIENCE_PLEASE_IDENTIFY_YOUR_SEX")
    
    let nextButtonTitle = L.string("UPDATE_STRING")
    let isLogoHidden = true
    
    init(view: MaleOrFemaleVCProtocol, profileRouter: ProfileRouterProtocol, networkManager: NetworkManagerProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
        super.init()
        self.view = view
        self.profileRouter = profileRouter
        self.networkManager = networkManager
    }
    
    func getSex() -> Sex? {
        return self.userDataModel.profile?.sex
    }
    
    func setSelectedSexToProfileModel(sex: Sex) {
        self.userDataModel.profile?.sex = sex
    }
    
    func btnNextTapped() {
        self.view.startIndicator()
        var userProfileToUpdate = UserProfileModel()
        userProfileToUpdate.sex = userDataModel.profile?.sex
        
        networkManager.updateUserProfile(profile: userProfileToUpdate, completion: { [weak self] responseModel, error in
            self?.networkManager.getUserInfo(completion: { [weak self] _, _ in
                NotificationCenter.default.post(name: .userInfoUpdated, object: self)
                self?.view.stopIndicator()
                self?.view.popVC()
            })
        })
        
    }

}
