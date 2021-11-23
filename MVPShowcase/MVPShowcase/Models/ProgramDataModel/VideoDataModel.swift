//
//  VideoDataModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

//MARK: - VideoDataModel
struct VideoDataModel: Codable {
    var museSvid: String?
    var id: String
    var title: String?
    var description: String?
    var largeThumbnail: String?
    var thumbnail: String?
    var videoType: [String]?
    var trainingEquipment: [String]?
    var exerciseComplexity: [String]?
    var linkedVideos: [VideoDataModel]?
    
    enum CodingKeys: String, CodingKey {
        case museSvid = "muse_svid"
        case id
        case title
        case description
        case largeThumbnail = "large_thumbnail"
        case thumbnail
        case videoType = "video_type"
        case trainingEquipment = "training_equipment"
        case exerciseComplexity = "exercise_complexity"
        case linkedVideos = "linked_videos"
    }
}
