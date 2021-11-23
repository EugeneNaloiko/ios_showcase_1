//
//  MyBadgesModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

struct MyBadgesModel: Codable {
    var id: String?
    var createTimestamp: TimeInterval?
    var updateTimestamp: TimeInterval?
    var deleteTimestamp: TimeInterval?
    var createdBy: String?
    var updatedBy: String?
    var deletedBy: String?
    var uuid: String?
    var badgeTypeId: String?
    var streakStart: String?
    var streakEnd: String?
    var hasUserBeenNotified: Bool?
    var streakLength: Int?
}
