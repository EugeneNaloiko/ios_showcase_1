//
//  ProfilePresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation
import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func getNumberOfSections() -> Int
    func getNumberOfRows(for section: Int) -> Int
    func getUserDataModel() -> UserInfoModel?
    
    func getSectionNameFor(section: Int) -> ProfileVCSection
    
    func personalDetailsTapped()
    
    func myProgramCellTapped()
    
    func myEquipmentsTapped()
    
    func changePasswordCellTapped()
    
    func aboutTapped()
    
    func privacyPolicyTapped()
    
    func termAndConditionsTapped()
    
    func logoutTapped()
}
