//
//  WorkoutDataModel.swift
//
//  Created by Eugene Naloiko on 04.08.2021.
//

import Foundation

//MARK: - WorkoutDataModel
struct WorkoutDataModel: Decodable {
    var id: Int?
    fileprivate var title: String?
    fileprivate var description: String?
    var thumbnail: String?
    var warmupVideos: [String]?
    var workoutVideos: [String]?
    var cooldownVideos: [String]?
    fileprivate var excerpt: String?
    var workoutType: [String]?
    var workoutIntensity: [String]?
    var workoutLevel: [String]?
    var trainingEquipmentIcons: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnail
        case warmupVideos = "warmup_videos"
        case workoutVideos = "workout_videos"
        case cooldownVideos = "cooldown_videos"
        case excerpt = "excerpt"
        case workoutType = "workout_type"
        case workoutIntensity = "workout_intensity"
        case workoutLevel = "workout_level"
        case trainingEquipmentIcons = "training_equipment_icons"
    }
    
    init(dateString: String) {
        self.dateString = dateString
    }
    
    //custom variables
    var isComplete: Bool = false
    var positionInCourse: Int!
    var dateString: String = ""
    var cycleName: String = ""
    var dayInProgram: String = ""
}

extension WorkoutDataModel {
    
    var workoutName: String {
        return self.title ?? ""
    }
    
    var workoutDescription: String {
        return self.excerpt ?? ""
    }
    
    var workoutDescriptionHtml: String {
        return self.description ?? ""
    }
    
}
