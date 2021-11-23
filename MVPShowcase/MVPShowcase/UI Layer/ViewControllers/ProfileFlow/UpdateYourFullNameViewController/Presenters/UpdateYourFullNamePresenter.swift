//
//  UpdateYourFullNamePresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class UpdateYourFullNamePresenter: BasePresenter, UpdateYourFullNamePresenterProtocol {
    
    weak var view: UpdateYourFullNameVCProtocol!
    weak var profileRouter: ProfileRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    private var userDataModel: UserInfoModel
    let isNavigationBarTransparent: Bool = false
    let navigationTitle: String? = L.string("FULL_NAME")
    let titleText = L.string("UPDATE_YOUR_FULLNAME")
    let descriptionText = L.string("PLAESE_UPDATE_YOUR_PROFILE_WITH_YOUR_LEGAL_NAME")

    let nextButtonTitle = L.string("UPDATE_STRING")
    let isLogoHidden = true
    
    init(view: UpdateYourFullNameVCProtocol, profileRouter: ProfileRouterProtocol, networkManager: NetworkManagerProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
        super.init()
        self.view = view
        self.profileRouter = profileRouter
        self.networkManager = networkManager
    }
    
    func getFullName() -> (firstName: String, lastName: String) {
        let firstName = self.userDataModel.profile?.firstName ?? ""
        let lastName = self.userDataModel.profile?.lastName ?? ""
        return (firstName, lastName)
    }
    
    func firstNameChangedTo(newFirstName: String) {
        self.userDataModel.profile?.firstName = newFirstName
    }
    
    func lastNameChangedTo(newLastName: String) {
        self.userDataModel.profile?.lastName = newLastName
    }
    
    func btnNextTapped() {
        self.view.startIndicator()
        var userProfileToUpdate = UserProfileModel()
        userProfileToUpdate.firstName = userDataModel.profile?.firstName
        userProfileToUpdate.lastName = userDataModel.profile?.lastName
        networkManager.updateUserProfile(profile: userProfileToUpdate, completion: { [weak self] responseModel, error in
            self?.networkManager.getUserInfo(completion: { [weak self] _, _ in
                NotificationCenter.default.post(name: .userInfoUpdated, object: self)
                self?.view.stopIndicator()
                self?.view.popVC()
            })
        })
    }

}
