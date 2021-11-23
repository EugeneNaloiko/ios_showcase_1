//
//  MaleOrFemalePresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class MaleOrFemalePresenter: BasePresenter, MaleOrFemalePresenterProtocol {
    
    weak var view: MaleOrFemaleVCProtocol!
    weak var loginRouter: LoginRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    private var userDataModel: UserInfoModel
    let isNavigationBarTransparent: Bool = true
    let navigationTitle: String? = nil
    let titleText = L.string("IDENTIFY_YOURSELF")
    let descriptionText = L.string("TO_PROVIDE_AN_OPTIONAL_EXPERIENCE_PLEASE_IDENTIFY_YOUR_SEX")

    let nextButtonTitle = L.string("CONTINUE_STRING")
    let isLogoHidden = false
    
    init(view: MaleOrFemaleVCProtocol, loginRouter: LoginRouterProtocol, networkManager: NetworkManagerProtocol, userDataModel: UserInfoModel) {
        self.userDataModel = userDataModel
        super.init()
        self.view = view
        self.loginRouter = loginRouter
        self.networkManager = networkManager
    }
    
    func getSex() -> Sex? {
        return self.userDataModel.profile?.sex
    }
    
    func setSelectedSexToProfileModel(sex: Sex) {
        self.userDataModel.profile?.sex = sex
    }
    
    func btnNextTapped() {
        
        self.loginRouter.showHowOldAreYouScreen(userDataModel: self.userDataModel)
    }

}
