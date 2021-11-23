//
//  PersonalDetailsPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation
import UIKit

protocol PersonalDetailsPresenterProtocol: AnyObject {
    var userDataModel: UserInfoModel? { get }
    var profileImage: UIImage? { get }
    
    func getNumberOfSections() -> Int
    func getNumberOfRows(for section: Int) -> Int
    
    func getSectionNameFor(section: Int) -> PersonalDetailsVCSections
    
    func getBirthDate() -> Date?
    
    func updateCountryCodeTo(newCountryCode: String)
    
    func uploadImage(image: UIImage)
    
    func fullNameCellTapped()
    func dateOfBirthCellTapped()
    func genderCellCellTapped()
    func fitnessLevelCellTapped()
}
