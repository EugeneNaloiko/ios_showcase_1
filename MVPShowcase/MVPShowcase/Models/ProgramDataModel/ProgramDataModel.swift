//
//  ProgramDataModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

struct ProgramDataModel: Decodable {
    var sku: String?
    var programDetails: ProgramDetailsModel?
    var trainingEquipment: [String]?
    fileprivate var workoutCalendarsData: [WaveDataModel]?
    var workoutReferenceData: [WorkoutDataModel]?
    var programTrailer: [String]?
    var pageData: [PageDataModel]?
    var coach: [String]?
    var programOverview: [String]?
    var quickStartGuide: [String]?
    var calendarOverview: [String]?
    var protocolOverview: [String]?
    var exerciseOverview: [String]?
    var exerciseInstruction: [String]?
    var firefighter: [String]?
    var system: [String]?
    var trainingEquipmentIcons: [String]?
    var videoData: [VideoDataModel]?
    
    enum ProgramDataModelCodingKeys: String, CodingKey {
        case sku
        case programDetails = "program_details"
        case trainingEquipment = "training_equipment"
        case workoutCalendarsData = "workout_calendars_data"
        case workoutReferenceData = "workout_reference_data"
        case programTrailer = "program_trailer"
        case pageData = "page_data"
        case coach
        case programOverview = "program_overview"
        case quickStartGuide = "quick_start_guide"
        case calendarOverview = "calendar_overview"
        case protocolOverview = "protocol_overview"
        case exerciseOverview = "exercise_overview"
        case exerciseInstruction = "exercise_instruction"
        case firefighter = "firefighter"
        case system = "system"
        case trainingEquipmentIcons = "training_equipment_icons"
        case videoData = "video_data"
    }
    
    init(from decoder: Decoder) throws {
        let modelContainer = try decoder.container(keyedBy: ProgramDataModelCodingKeys.self)
        
        self.programDetails = try? modelContainer.decode(ProgramDetailsModel?.self, forKey: .programDetails)
        self.trainingEquipment = try? modelContainer.decode([String]?.self, forKey: .trainingEquipment)
        self.workoutCalendarsData = try? modelContainer.decode([WaveDataModel]?.self, forKey: .workoutCalendarsData)
        self.workoutReferenceData = try? modelContainer.decode([WorkoutDataModel]?.self, forKey: .workoutReferenceData)
        self.programTrailer = try? modelContainer.decode([String]?.self, forKey: .programTrailer)
        self.pageData = try? modelContainer.decode([PageDataModel]?.self, forKey: .pageData)
        self.coach = try? modelContainer.decode([String]?.self, forKey: .coach)
        self.programOverview = try? modelContainer.decode([String]?.self, forKey: .programOverview)
        self.quickStartGuide = try? modelContainer.decode([String]?.self, forKey: .quickStartGuide)
        self.calendarOverview = try? modelContainer.decode([String]?.self, forKey: .calendarOverview)
        self.protocolOverview = try? modelContainer.decode([String]?.self, forKey: .protocolOverview)
        self.exerciseOverview = try? modelContainer.decode([String]?.self, forKey: .exerciseOverview)
        self.exerciseInstruction = try? modelContainer.decode([String]?.self, forKey: .exerciseInstruction)
        self.firefighter = try? modelContainer.decode([String]?.self, forKey: .firefighter)
        self.system = try? modelContainer.decode([String]?.self, forKey: .system)
        self.trainingEquipmentIcons = try? modelContainer.decode([String]?.self, forKey: .trainingEquipmentIcons)
        self.videoData = try? modelContainer.decode([VideoDataModel]?.self, forKey: .videoData)
        if let sku = (try? modelContainer.decode(String.self, forKey: .sku)) {
            self.sku = sku
            for (index, item) in (workoutCalendarsData ?? []).enumerated() {
                var item = item
                item.programSku = sku
                workoutCalendarsData?[index] = item
            }
        }
    }
    
}

extension ProgramDataModel {
    
    func getProgramDuration() -> Int {
        var duration = 0
        for item in self.workoutCalendarsData ?? [] {
            if item.workoutDays.count > duration {
                duration = item.workoutDays.count
            }
        }
        return duration
    }
    
    func getProgramLinkedVideos() -> [VideoDataModel] {
        var relatedVideos: [VideoDataModel] = []
        
        for video in self.videoData ?? [] {
            for linkedVideo in video.linkedVideos ?? [] {
                if !relatedVideos.contains(where: { $0.id == linkedVideo.id }) {
                    relatedVideos.append(linkedVideo)
                }
            }
        }
        
        return relatedVideos
    }
    
    var programWaves: [WaveDataModel] {
        return self.workoutCalendarsData ?? []
    }
    
    var workouts: [WorkoutDataModel?] {
        guard let sku = self.sku else { return [] }
        return StorageDataManager.shared.getAllworkoutsWithDetailInfo(programSku: sku,
                                                                      workoutsForFillingDetailInfo: self.workoutCalendarsData ?? [])
    }
    
    var description: String? {
        return programDetails?.contentClean
    }
    
    var thumbnailImageUrl: String? {
        return programDetails?.thumbnail
    }
}
