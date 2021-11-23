//
//  LeaderboardModel.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

struct LeaderboardModel: Codable {
    var uuid: String?
    var badgeCount: Int?
    var totalPoints: Int?
    var firstName: String?
    var lastName: String?
    var countryCode: String?
    var profileImageId: String?
    var position: Int?
    var profileImageData: Data?
 }
