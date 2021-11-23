//
//  WaveDataModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

//MARK: - WaveDataModel
struct WaveDataModel: Decodable {
    var programSku: String?
    fileprivate var data: [Any]?
    var id: String
    fileprivate var title: String?
    var excerptClean: String?
    var thumbnail: String?
    var imageFul: String?
    var daysInCycle: Int?
    
    enum WorkoutCalendarsDataModelCodingKeys: String, CodingKey {
        case data
        case id
        case title
        case thumbnail
        case imageFul = "image_ful"
        case daysInCycle = "days_in_cycle"
        case excerptClean = "excerpt_clean"
    }
    
    init(from decoder: Decoder) throws {
        let modelContainer = try decoder.container(keyedBy: WorkoutCalendarsDataModelCodingKeys.self)
        data = try? modelContainer.decode([Any].self, forKey: .data)
        id = try modelContainer.decode(String.self, forKey: .id)
        title = try? modelContainer.decode(String?.self, forKey: .title)
        excerptClean = try? modelContainer.decode(String?.self, forKey: .excerptClean)
        thumbnail = try? modelContainer.decode(String?.self, forKey: .thumbnail)
        imageFul = try? modelContainer.decode(String?.self, forKey: .imageFul)
        daysInCycle = try? modelContainer.decode(Int.self, forKey: .daysInCycle)
    }
    
}

extension WaveDataModel {
    
    var waveName: String {
        return self.title ?? ""
    }

    var isWaveAvailableForUser: Bool {
        for item in data ?? [] {
            if let boolValue = item as? Bool {
                return boolValue
            }
        }
        return false
    }

    var workoutDays: [WorkoutDataModel?] {
        var days: [WorkoutDataModel?] = []
        for item in data ?? [] {
            if let intValue = item as? Int {
                if intValue != 0 {
                    let workoutDetailInfo = StorageDataManager.shared.getWorkoutInfoById(programSku: self.programSku!, workoutId: intValue)
                    days.append(workoutDetailInfo)
                } else {
                    days.append(nil)
                }
                
            }
        }
        return days
    }
    
//    var workoutDays: [Int] {
//        var days: [Int] = []
//        for item in data ?? [] {
//            if let intValue = item as? Int {
//                days.append(intValue)
//            }
//        }
//        return days
//    }

    var numberOfCycles: Int {
        guard let days = daysInCycle else { return 0 }
        let count = workoutDays.count / days
        return count
    }
    
}
