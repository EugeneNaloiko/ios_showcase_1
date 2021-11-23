//
//  WorkoutExerciseProgressDataModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

struct WorkoutExerciseProgressDataModel: Codable {
    var id: String?
    var createTimestamp: TimeInterval?
    var updateTimestamp: TimeInterval?
    var deleteTimestamp: TimeInterval?
    var uuid: String?
    var userProgramId: String?
    var programSku: String?
    var workoutId: String?
    var workoutPositionInProgram: Int?
    var completionDate: String?
    var tedData: TedDataDataModel?
}

