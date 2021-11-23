//
//  ProfileVCSections.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

//MARK: - Sections
enum ProfileVCSection {
    case profileInfoSection(cells: [ProfileInfoCell])
    case settingsSection(cells: [ProfileSettingsCell])
    case legalSection(cells: [ProfileLegalSection])
}

//MARK: - Cells
enum ProfileInfoCell {
    case personalDetailsCell
    case myProgramCell
    case myEquipmentsCell
}

enum ProfileSettingsCell {
    case pushNotificationCell
    case remindMeToExerciseCell
    case changePasswordCell
    case aboutCell
}

enum ProfileLegalSection {
    case privacyPolicyCell
    case termAndConditionsCell
    case emptyCell
    case logoutCell
}
