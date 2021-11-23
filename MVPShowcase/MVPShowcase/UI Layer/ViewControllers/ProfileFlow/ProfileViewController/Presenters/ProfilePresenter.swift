//
//  ProfilePresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation
import UIKit


final class ProfilePresenter: BasePresenter, ProfilePresenterProtocol {
    
    private var profileRouter: ProfileRouterProtocol!
    
    weak var view: ProfileViewProtocol!
    
    var networkManager: NetworkManagerProtocol!
    
    private let aboutUrl = "https://showcase.com/about"
    private let privacyPolicyUrl = "https://showcase.com/term-and-conditions"
    private let termAndConditionsUrl = "https://showcase.com/term-and-conditions"
    
    private var sectionsArray: [ProfileVCSection] = []
    
    private var profileImage: UIImage?
    
    init(profileRouter: ProfileRouterProtocol, view: ProfileViewProtocol, networkManager: NetworkManagerProtocol) {
        super.init()
        self.profileRouter = profileRouter
        self.view = view
        self.networkManager = networkManager
        self.setupSections()
    }
    
    func viewDidLoad() {
        self.getProfileImageFromServer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getProfileImageFromServer), name: NSNotification.Name.profileImageDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUserFullName), name: NSNotification.Name.userInfoUpdated, object: nil)
    }
    
    @objc private func refreshUserFullName() {
        let firstName = StorageDataManager.shared.userDataModel?.profile?.firstName ?? ""
        let lastName = StorageDataManager.shared.userDataModel?.profile?.lastName ?? ""
        self.view.updateFullName(firstName: firstName, lastName: lastName)
    }
    
    private func setupSections() {
        self.sectionsArray = [
            .profileInfoSection(cells: [
                .personalDetailsCell,
                .myProgramCell,
                .myEquipmentsCell
            ]),
            .settingsSection(cells: [
                .changePasswordCell,
                .aboutCell
            ]),
            .legalSection(cells: [
                .termAndConditionsCell,
                .emptyCell,
                .logoutCell
            ])
        ]
    }
    
    func getNumberOfSections() -> Int {
        return self.sectionsArray.count
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        let sectionName = self.sectionsArray[section]
        switch sectionName {
        case.profileInfoSection(let cells):
            return cells.count
        case .settingsSection(let cells):
            return cells.count
        case .legalSection(let cells):
            return cells.count
        }
    }
    
    @objc private func getProfileImageFromServer() {
        guard let imageId = StorageDataManager.shared.userDataModel?.profileImageId else { return }
        
        self.networkManager.getProfileImage(imageId: imageId, completion: { [weak self] imageData, error in
            guard let sSelf = self else { return }
            guard let imageData = imageData else { return }
            guard let image = UIImage(data: imageData) else { return }
            sSelf.profileImage = image
            sSelf.view.updateProfileImage(image: image)
        })
    }
    
    func getUserDataModel() -> UserInfoModel? {
        let userDataModel = StorageDataManager.shared.userDataModel
        return userDataModel
    }
    
    func getSectionNameFor(section: Int) -> ProfileVCSection {
        let sectionName = self.sectionsArray[section]
        return sectionName
    }
    
    func personalDetailsTapped() {
        self.profileRouter.showPersonalDetailsScreen(profileImage: self.profileImage)
    }
    
    func myProgramCellTapped() {
        assertionFailure("STUB")
    }
    
    func myEquipmentsTapped() {
        assertionFailure("STUB")
    }
    
    func changePasswordCellTapped() {
        self.profileRouter.showUpdatePasswordScreen()
    }
    
    func aboutTapped() {
        guard let url = URL(string: aboutUrl) else { return }
        self.view.openSafari(url: url)
    }
    
    func privacyPolicyTapped() {
        guard let url = URL(string: privacyPolicyUrl) else { return }
        self.view.openSafari(url: url)
    }
    
    func termAndConditionsTapped() {
        guard let url = URL(string: termAndConditionsUrl) else { return }
        self.view.openSafari(url: url)
    }
    
    func logoutTapped() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.networkManager.authLogout(completion: nil)
        }
        self.networkManager.performForceLogoutClosure?()
    }
}
