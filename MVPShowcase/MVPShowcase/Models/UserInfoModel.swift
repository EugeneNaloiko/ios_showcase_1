//
//  UserInfoModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

enum FitnessLevel: String, Codable {
    case startingLevel = "JUST_STARTING"
    case okLevel = "OK"
    case veryFitLevel = "VERY_FIT"
    
    var title: String {
        switch self {
        case .startingLevel:
            return L.string("NOVICE_STRING")
        case .okLevel:
            return L.string("EXPERIENCED_STRING")
        case .veryFitLevel:
            return L.string("PROFESSIONAL_STRING")
        }
    }
}

enum FitnessEquipment: String, Codable, CaseIterable {
    case FitnessEquipmentOne = "FitnessEquipmentOne"
    case FitnessEquipmentTwo = "FitnessEquipmentTwo"
    
    var imageName: String {
        switch self {
        case .FitnessEquipmentOne:
            return "img_FitnessEquipmentOne"
        case .FitnessEquipmentTwo:
            return "img_FitnessEquipmentTwo"
        }
    }
    
    var equipmentName: String {
        switch self {
        case .FitnessEquipmentOne:
            return L.string("FitnessEquipmentOne")
        case .FitnessEquipmentTwo:
            return L.string("FitnessEquipmentTwo")
        }
    }
    
}

enum Sex: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
    
    var title: String {
        switch self {
        case .male:
            return L.string("MALE")
        case .female:
            return L.string("FEMALE")
        }
    }
      
}

struct UserInfoModel: Codable {
    var createTimestamp: Int64?
    var createdBy: String?
    var deleteTimestamp: Int64?
    var deletedBy: String?
    var email: String?
    var forcePasswordChange: Bool?
    var id: String?
    var isActive: Bool?
    var preferences: UserPreferencesModel?
    var profile: UserProfileModel?
    var updateTimestamp: Int64?
    var updatedBy: String?
    var uuid: String?
    var profileImageId: String?
}

struct UserPreferencesModel: Codable {
    var sendEmails: Bool?
}

struct UserProfileModel: Codable {
    var birthDate: String?
    var countryCode: String?
    var currentFitnessLevel: FitnessLevel? //[ JUST_STARTING, OK, VERY_FIT ]
    var fitnessEquipment: [FitnessEquipment]?
    var firstName: String?
    var lastName: String?
    var fullName: String?
    var password: String?
    var phoneNumber: String?
    var sex: Sex? //[ MALE, FEMALE ]
}
