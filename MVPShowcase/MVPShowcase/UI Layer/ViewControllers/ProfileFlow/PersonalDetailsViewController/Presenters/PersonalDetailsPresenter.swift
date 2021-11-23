//
//  PersonalDetailsPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation
import UIKit

final class PersonalDetailsPresenter: BasePresenter, PersonalDetailsPresenterProtocol {
    
    private var profileRouter: ProfileRouterProtocol!
    
    weak var view: PersonalDetailsVCProtocol!
    
    var networkManager: NetworkManagerProtocol!
    
    private var sectionsArray: [PersonalDetailsVCSections] = []
    
    var userDataModel: UserInfoModel? {
        get {
            return StorageDataManager.shared.userDataModel
        }
    }
    
    var profileImage: UIImage?
    
    
    init(profileRouter: ProfileRouterProtocol, view: PersonalDetailsVCProtocol, networkManager: NetworkManagerProtocol, profileImage: UIImage?) {
        super.init()
        self.profileRouter = profileRouter
        self.view = view
        self.networkManager = networkManager
        self.profileImage = profileImage
        self.setupSections()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshInfoOnView), name: NSNotification.Name.userInfoUpdated, object: nil)
    }
    
    @objc private func refreshInfoOnView() {
        self.view.reloadTableView()
    }
    
    private func setupSections() {
        self.sectionsArray = [
            .imageSection,
            .profileInfoSection(cells: [
                                    .fullNameCell,
                                    .dateOfBirthCell,
                                    .genderCell
            ]),
            .contactDetailsSection(cells: [
                                    .emailAddressCell,
                                    .countryCell
            ]),
            .moreSection(cells: [
                .fitnessLevelCell
            ])
        ]
    }
    
    func getNumberOfSections() -> Int {
        return self.sectionsArray.count
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        let sectionName = self.sectionsArray[section]
        switch sectionName {
        case .imageSection:
            return 0
        case.profileInfoSection(let cells):
            return cells.count
        case .contactDetailsSection(let cells):
            return cells.count
        case .moreSection(let cells):
            return cells.count
        }
    }
    
    func getSectionNameFor(section: Int) -> PersonalDetailsVCSections {
        let sectionName = self.sectionsArray[section]
        return sectionName
    }
    
    func getBirthDate() -> Date? {
        if let date = self.userDataModel?.profile?.birthDate?.toDateIgnoreAnyTimeZone() {
            return date
        } else if let date = self.userDataModel?.profile?.birthDate?.toDateIgnoreAnyTimeZone(dateFormat: "YYYY-MM-dd'T'HH:mm:ss.SSSZ") {
            return date
        } else {
            return nil
        }
    }
    
    func updateCountryCodeTo(newCountryCode: String) {
        StorageDataManager.shared.userDataModel?.profile?.countryCode = newCountryCode
        var userProfileToUpdate = UserProfileModel()
        userProfileToUpdate.countryCode = userDataModel?.profile?.countryCode
        networkManager.updateUserProfile(profile: userProfileToUpdate, completion: { [weak self] responseModel, error in
            self?.view.reloadTableView()
        })
    }
    
    func uploadImage(image: UIImage) {
        
        guard let data = image.jpegData(compressionQuality: 0.80) else { return }
        
        self.networkManager.uploadImage(imageData: data, completion: { [weak self] responseDataModel, error in
            if let dataModel = responseDataModel {
                StorageDataManager.shared.userDataModel?.profileImageId = dataModel.id
                NotificationCenter.default.post(name: .profileImageDidUpdate, object: self)
            }
        })
    }
    
    func fullNameCellTapped() {
        guard let userDataModel = self.userDataModel else { return }
        self.profileRouter.showUpdateYourFullNameScreen(userDataModel: userDataModel)
    }
    
    func dateOfBirthCellTapped() {
        guard let userDataModel = self.userDataModel else { return }
        self.profileRouter.showUpdateDateOfBirthScreen(userDataModel: userDataModel)
    }
    
    func genderCellCellTapped() {
        guard let userDataModel = self.userDataModel else { return }
        self.profileRouter.showUpdateMaleOrFemaleScreen(userDataModel: userDataModel)
    }
    
    func fitnessLevelCellTapped() {
        guard let userDataModel = self.userDataModel else { return }
        self.profileRouter.showUpdateCurrentFitnessLevelScreen(userDataModel: userDataModel)
    }
    
}
