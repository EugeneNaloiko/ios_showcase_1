//
//  CurrentFitnessLevelPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class CurrentFitnessLevelPresenter: BasePresenter, CurrentFitnessLevelPresenterProtocol {
    
    weak var view: CurrentFitnessLevelVCProtocol!
    weak var loginRouter: LoginRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    private var userDataModel: UserInfoModel
    let isNavigationBarTransparent: Bool = true
    let navigationTitle: String? = nil
    let titleText = L.string("WHATS_YOUR_CURRENT_FITNESS_LEVEL")
    let descriptionText = L.string("WE_WILL_CUSTOMIZE_YOUR_EXPERIENCE_BASED_ON_YOUR_SELECTIONS")

    let nextButtonTitle = L.string("CONTINUE_STRING")
    let isLogoHidden = false
    
    init(view: CurrentFitnessLevelVCProtocol, loginRouter: LoginRouterProtocol, networkManager: NetworkManagerProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
        super.init()
        self.view = view
        self.loginRouter = loginRouter
        self.networkManager = networkManager
    }
    
    func setSelectedFitnessLevel(fitnessLevel: FitnessLevel) {
        self.userDataModel.profile?.currentFitnessLevel = fitnessLevel
    }
    
    func getCurrentFitnessLevel() -> FitnessLevel? {
        return self.userDataModel.profile?.currentFitnessLevel
    }
    
    func btnNextTapped() {
        assertionFailure("STUB")
    }
}
