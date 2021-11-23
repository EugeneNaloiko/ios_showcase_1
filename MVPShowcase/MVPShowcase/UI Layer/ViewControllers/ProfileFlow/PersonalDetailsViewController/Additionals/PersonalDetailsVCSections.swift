//
//  PersonalDetailsVCSections.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

//MARK: - Sections
enum PersonalDetailsVCSections {
    case imageSection
    case profileInfoSection(cells: [ProfileInfoSectionCell])
    case contactDetailsSection(cells: [contactDetailsSectionCell])
    case moreSection(cells: [MoreSectionCell])
}

//MARK: - Cells
enum ProfileInfoSectionCell {
    case fullNameCell
    case dateOfBirthCell
    case genderCell
}

enum contactDetailsSectionCell {
    case emailAddressCell
    case countryCell
}

enum MoreSectionCell {
    case fitnessLevelCell
}
