//
//  UpdateDateOfBirthPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class UpdateDateOfBirthPresenter: BasePresenter, HowOldAreYouPresenterProtocol {
    
    weak var view: HowOldAreYouVCProtocol!
    weak var profileRouter: ProfileRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    private var userDataModel: UserInfoModel
    let isNavigationBarTransparent: Bool = false
    let navigationTitle: String? = L.string("DATE_OF_BIRTH")
    let titleText = L.string("WHAT_IS_YOUR_BIRTH_DATE")
    let descriptionText = L.string("WE_WILL_CUSTOMIZE_YOUR_HEART_RATE_INTENSITY_RECOMMENDATIONS")
    
    let nextButtonTitle = L.string("UPDATE_STRING")
    let isLogoHidden = true
    
    init(view: HowOldAreYouVCProtocol, profileRouter: ProfileRouterProtocol, networkManager: NetworkManagerProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
        super.init()
        self.view = view
        self.profileRouter = profileRouter
        self.networkManager = networkManager
    }
    
    func getBirthDate() -> Date? {
        if let date = self.userDataModel.profile?.birthDate?.toDateIgnoreAnyTimeZone() {
            return date
        } else if let date = self.userDataModel.profile?.birthDate?.toDateIgnoreAnyTimeZone(dateFormat: "YYYY-MM-dd'T'HH:mm:ss.SSSZ") {
            return date
        } else {
            return nil
        }
            
//            self.presenter.userDataModel?.profile?.birthDate?.toDateIgnoreAnyTimeZone(dateFormat: "YYYY-MM-dd'T'HH:mm:ss.SSSZ") {
//            cell.setTitle(titleText: date.toString(dateFormat: "yyyy-MM-dd"))
        
//        return self.userDataModel.profile?.birthDate?.toDateIgnoreAnyTimeZone()
    }
    
    func setBirthDateTo(dateString: String?) {
        self.userDataModel.profile?.birthDate = dateString
    }
    
    func btnNextTapped() {
        self.view.startIndicator()
        var userProfileToUpdate = UserProfileModel()
        userProfileToUpdate.birthDate = userDataModel.profile?.birthDate
        networkManager.updateUserProfile(profile: userProfileToUpdate, completion: { [weak self] responseModel, error in
            self?.networkManager.getUserInfo(completion: { [weak self] _, _ in
                NotificationCenter.default.post(name: .userInfoUpdated, object: self)
                self?.view.stopIndicator()
                self?.view.popVC()
            })
        })
        
    }

}
