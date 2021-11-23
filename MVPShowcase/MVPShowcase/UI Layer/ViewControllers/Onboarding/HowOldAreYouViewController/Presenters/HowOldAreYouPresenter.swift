//
//  HowOldAreYouPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class HowOldAreYouPresenter: BasePresenter, HowOldAreYouPresenterProtocol {
    
    weak var view: HowOldAreYouVCProtocol!
    weak var loginRouter: LoginRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    private var userDataModel: UserInfoModel
    let isNavigationBarTransparent: Bool = true
    let navigationTitle: String? = nil
    let titleText = L.string("WHAT_IS_YOUR_BIRTH_DATE")
    let descriptionText = L.string("WE_WILL_CUSTOMIZE_YOUR_HEART_RATE_INTENSITY_RECOMMENDATIONS")

    let nextButtonTitle = L.string("CONTINUE_STRING")
    let isLogoHidden = false
    
    init(view: HowOldAreYouVCProtocol, loginRouter: LoginRouterProtocol, networkManager: NetworkManagerProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
        super.init()
        self.view = view
        self.loginRouter = loginRouter
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
//        return self.userDataModel.profile?.birthDate?.toDateIgnoreAnyTimeZone()
    }
    
    func setBirthDateTo(dateString: String?) {
        self.userDataModel.profile?.birthDate = dateString
    }
    
    func btnNextTapped() {
        self.loginRouter.showCurrentFitnessLevelScreen(userDataModel: self.userDataModel)
    }

}
