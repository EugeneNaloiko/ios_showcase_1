//
//  DashboardInfoModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

struct DashboardInfoModel: Decodable {
    var trending: [TrendingModel]?
    var workoutCategories: [WorkoutCategoriesDataModel]?
    var recommendedTraining: [ProgramDataModel]?
    var today: [ProgramDataModel]?
    var allPrograms: [ProgramDataModel]?
    var purchasedPrograms: [String]?
    var currentStreakLength: Int?
}

//MARK: - TRENDING
struct TrendingModel: Decodable {
    var program: ProgramDataModel?
}

//MARK: - WorkoutCategories
struct WorkoutCategoriesDataModel: Codable {
    var id: Int
    var name: String?
    var smallImage: String?
    var largeImage: String?
}



