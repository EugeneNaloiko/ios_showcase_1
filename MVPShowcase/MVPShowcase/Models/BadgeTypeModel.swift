//
//  BadgeTypeModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

struct BadgeTypeModel: Codable {
    var id: String?
    var createTimestamp: TimeInterval?
    var updateTimestamp: TimeInterval?
    var deleteTimestamp: TimeInterval?
    var createdBy: String?
    var updatedBy: String?
    var deletedBy: String?
    var numberDaysStreakRequired: Int?
    var isStreakType: Bool?
    var badgeName: String?
    var activeImageUrl: String?
    var inactiveImageUrl: String?
    var pointsAwarded: Int?
    var howToEarnText: String?
    var congratsText: String?
    var alreadyEarnedText: String?
}
