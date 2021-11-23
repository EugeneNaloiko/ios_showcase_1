//
//  CompleteWorkoutBodyDataModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

struct CompleteWorkoutBodyDataModel: Codable {
    var userProgramId: String
    var programSku: String
    var workoutId: String
    var workoutPositionInProgram: Int
    var completionDate: String
    var tedData: TedDataDataModel?
}
