//
//  EnrolDataModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

struct UserProgramModel: Codable {
    var id: String?
    var createTimestamp: TimeInterval?
    var updateTimestamp: TimeInterval?
    var deleteTimestamp: TimeInterval?
    var createdBy: String?
    var updatedBy: String?
    var deletedBy: String?
    var uuid: String?
    var programSku: String?
    var currentPositionInCourse: Int?
    var reIndexDate: String?
    var selectedWave: String?
    var isActive: Bool?
    var pauseDate: String?
}
