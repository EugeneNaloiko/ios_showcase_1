//
//  StorageDataManager.swift
//
//  Created by Eugene Naloiko on 16.06.2021.
//

import Foundation

class StorageDataManager {
    
    static let shared = StorageDataManager()
    
    var environment: NetworkEnvironment = .STAGING
    
    var authDataModel: AuthenticationModel?
    
    var dashboardInfo: DashboardInfoModel?
    
    var userDataModel: UserInfoModel?
    
    var userPrograms: [UserProgramModel]?
    
    var allWorkoutExerciseProgress: [WorkoutExerciseProgressDataModel] = [] {
        didSet {
            NotificationCenter.default.post(name: .workoutExersiceProgressUpdated, object: self)
        }
    }
    
    private var allMuseVideosinfo: [AllMuseVideosModel] = []
    
    
    func cleanSavedDataForLogout() {
        self.authDataModel = nil
        self.dashboardInfo = nil
        self.userDataModel = nil
        self.userPrograms = nil
        self.allWorkoutExerciseProgress = []
        self.allMuseVideosinfo = []
    }
    
    func updateAllMuseVideosInfo(allMuseVideos: [AllMuseVideosModel]) {
        self.allMuseVideosinfo = allMuseVideos
    }
    
    func getDetailInfoForVideoBy(svid: String) -> AllMuseVideosModel? {
        return allMuseVideosinfo.first(where: {$0.svid == svid})
    }
    
    func getAllworkoutsWithDetailInfo(programSku: String, workoutsForFillingDetailInfo: [WaveDataModel]) -> [WorkoutDataModel?] {
        var currentProgram: UserProgramModel?
        var workoutsFullInfo: [WorkoutDataModel?] = []
        
        for program in userPrograms ?? [] {
            if program.programSku == programSku {
                currentProgram = program
            }
        }
        
        guard let currentProgram = currentProgram else {
            return [WorkoutDataModel]()
        }
        
        let currentPosition = currentProgram.currentPositionInCourse! - 1
        let reIndexDate = currentProgram.reIndexDate ?? ""
        
        var currentWave: WaveDataModel?
        
        for wave in workoutsForFillingDetailInfo {
            if currentProgram.selectedWave == wave.id {
                currentWave = wave
            }
        }
        
        let numberOfWorkoutsInOneCycle = currentWave?.daysInCycle ?? 0
        
        var cycleCounter = 1
        
        var tempArray: [WorkoutDataModel?] = []
        
        for (index, workoutDay) in (currentWave?.workoutDays ?? []).enumerated() {
            var workout = workoutDay
            workout?.positionInCourse = index
            
            if index < (currentPosition - 1) {
                let daysForSubtract = (currentPosition - 1) - index
                let workoutDate = reIndexDate.addDays(numberOfDays: -daysForSubtract)
                
                if workout != nil {
                    workout?.dateString = workoutDate
                    workout?.isComplete = true
                } else {
                    let rest = WorkoutDataModel(dateString: workoutDate)
                    workout = rest
                }
            } else if currentPosition == 0 {
                let daysToAdd = index - currentPosition
                let workoutDate = reIndexDate.addDays(numberOfDays: daysToAdd)
                
                if workout != nil {
                    workout?.dateString = workoutDate
                    workout?.isComplete = false
                } else {
                    let rest = WorkoutDataModel(dateString: workoutDate)
                    workout = rest
                }
            } else {
                let daysToAdd = index - (currentPosition - 1)
                let workoutDate = reIndexDate.addDays(numberOfDays: daysToAdd)
                if workout != nil {
                    workout?.dateString = workoutDate
                    workout?.isComplete = false
                } else {
                    let rest = WorkoutDataModel(dateString: workoutDate)
                    workout = rest
                }
            }
            
            //fill cycle name and day number in program for workout
            tempArray.append(workout)
            
            if tempArray.count != numberOfWorkoutsInOneCycle {
                let cycleName = "\(L.string("CYCLE_STRING")) \(cycleCounter)"
                workout?.cycleName = cycleName
                
                let dayInProgram = "\(L.string("DAY_STRING")) \(tempArray.count)".capitalizingFirstLetter()
                workout?.dayInProgram = dayInProgram
            } else {
                let cycleName = "\(L.string("CYCLE_STRING")) \(cycleCounter)"
                workout?.cycleName = cycleName
                let dayInProgram = "\(L.string("DAY_STRING")) \(tempArray.count)".capitalizingFirstLetter()
                workout?.dayInProgram = dayInProgram
                //                for (index, _) in tempArray.enumerated() {
                //                    let dayInProgram = "\(L.string("DAY_STRING")) \(index + 1)".capitalizingFirstLetter()
                //                    tempArray[index]?.dayInProgram = dayInProgram
                //                }
                
                tempArray = []
                cycleCounter += 1
            }
            
            workoutsFullInfo.append(workout)
            
        }
        
        return workoutsFullInfo
    }
    
    func getInstructionalsForWorkout(selectedProgram: ProgramDataModel, selectedWorkout: WorkoutDataModel) ->  [VideoDataModel] {
        var allWorkoutVideosIds: [String] = (selectedWorkout.warmupVideos ?? []) + (selectedWorkout.workoutVideos ?? []) + (selectedWorkout.cooldownVideos ?? [])
        allWorkoutVideosIds.removeDuplicates()
        
        var allWorkoutInstructionalVideos: [VideoDataModel] = []
        
        //MARK: setup allWorkoutVideos
        for videoId in allWorkoutVideosIds {
            for video in selectedProgram.videoData ?? [] {
                if videoId == video.id {
                    for linkedVideo in video.linkedVideos ?? [] {
                        //                        if videoId == linkedVideo.id {
                        if (linkedVideo.videoType ?? []).contains(where: {$0 == "Instructional"}) {
                            if !allWorkoutInstructionalVideos.contains(where: {$0.id == video.id}) {
                                allWorkoutInstructionalVideos.append(linkedVideo)
                            }
                        }
                        //                        }
                    }
                }
            }
        }
        return allWorkoutInstructionalVideos
    }
    
    func getWarmUpVideosForWorkout(selectedProgram: ProgramDataModel, selectedWorkout: WorkoutDataModel) -> [VideoDataModel] {
        let warmUpVideosIds: [String] = selectedWorkout.warmupVideos ?? []
        
        var warmUpVideos: [VideoDataModel] = []
        
        //MARK: setup warmUpVideos
        for warmUpVideoId in warmUpVideosIds {
            for video in selectedProgram.videoData ?? [] {
                if video.id == warmUpVideoId {
                    if !warmUpVideos.contains(where: {$0.id == video.id}) {
                        warmUpVideos.append(video)
                    }
                }
            }
        }
        
        return warmUpVideos
    }
    
    func getWorkoutVideosForWorkout(selectedProgram: ProgramDataModel, selectedWorkout: WorkoutDataModel) -> [VideoDataModel] {
        let workoutVideosIds: [String] = selectedWorkout.workoutVideos ?? []
        var workoutVideos: [VideoDataModel] = []
        
        //MARK: setup workoutVideos
        for workoutVideoId in workoutVideosIds {
            for video in selectedProgram.videoData ?? [] {
                if video.id == workoutVideoId {
                    if !workoutVideos.contains(where: {$0.id == video.id}) {
                        workoutVideos.append(video)
                    }
                }
            }
        }
        
        return workoutVideos
    }
    
    func getCooldownVideosForWorkout(selectedProgram: ProgramDataModel, selectedWorkout: WorkoutDataModel) -> [VideoDataModel] {
        let cooldownVideosIds: [String] = selectedWorkout.cooldownVideos ?? []
        var cooldownVideos: [VideoDataModel] = []
        
        //MARK: setup cooldownVideos
        for cooldownVideosId in cooldownVideosIds {
            for video in selectedProgram.videoData ?? [] {
                if video.id == cooldownVideosId {
                    if !cooldownVideos.contains(where: {$0.id == video.id}) {
                        cooldownVideos.append(video)
                    }
                }
            }
        }
        return cooldownVideos
    }
    
    func getRelatedVideosForWorkout(selectedProgram: ProgramDataModel, selectedWorkout: WorkoutDataModel) -> [VideoDataModel] {
        let warmUpVideos: [VideoDataModel] = self.getWarmUpVideosForWorkout(selectedProgram: selectedProgram, selectedWorkout: selectedWorkout)
        let workoutVideos: [VideoDataModel] = self.getWorkoutVideosForWorkout(selectedProgram: selectedProgram, selectedWorkout: selectedWorkout)
        let cooldownVideos: [VideoDataModel] = self.getCooldownVideosForWorkout(selectedProgram: selectedProgram, selectedWorkout: selectedWorkout)
        
        var relatedWorkoutVideos: [VideoDataModel] = []
        
        for warmUpVideo in warmUpVideos {
            if let linkedVideos = warmUpVideo.linkedVideos, !linkedVideos.isEmpty {
                relatedWorkoutVideos += linkedVideos
            }
        }
        
        for workoutVideo in workoutVideos {
            if let linkedVideos = workoutVideo.linkedVideos, !linkedVideos.isEmpty {
                relatedWorkoutVideos += linkedVideos
            }
        }
        
        for cooldownVideo in cooldownVideos {
            if let linkedVideos = cooldownVideo.linkedVideos, !linkedVideos.isEmpty {
                relatedWorkoutVideos += linkedVideos
            }
        }
        
        return relatedWorkoutVideos
    }
    
    func getWorkoutInfoById(programSku: String, workoutId: Int) -> WorkoutDataModel? {
        
        for program in dashboardInfo?.allPrograms ?? [] {
            if program.sku == programSku {
                for data in program.workoutReferenceData ?? [] {
                    //                    print(data.id)
                    if let id = data.id, Int(id) == workoutId {
                        return data
                    }
                }
            }
        }
        return nil
    }
    
    func getPurchasedPrograms() -> [ProgramDataModel] {
        var purchasedPrograms: [ProgramDataModel] = []
        
        for purchasedProgramSku in StorageDataManager.shared.dashboardInfo?.purchasedPrograms ?? [] {
            for program in StorageDataManager.shared.dashboardInfo?.allPrograms ?? [] {
                if program.sku == purchasedProgramSku {
                    purchasedPrograms.append(program)
                }
            }
        }
        return purchasedPrograms
    }
    
    func getProgramBySku(sku: String) -> ProgramDataModel? {
        for program in self.dashboardInfo?.allPrograms ?? [] {
            if program.sku == sku {
                return program
            }
        }
        return nil
    }
    
    func isTodayRecoveryDay() -> Bool {
        let userPrograms = StorageDataManager.shared.userPrograms ?? []
        
        var programsWithDetails: [ProgramDataModel] = []
        
        let currentDate = Date().toDateIgnoreAnyTimeZone()
        
        
        for workout in allWorkoutExerciseProgress {
            if workout.completionDate == currentDate?.toString(), workout.workoutId == "TOOK_A_BREAK" {
                return true
            }
        }
        
        
        for userProgram in userPrograms {
            if userProgram.pauseDate == nil {
                if let programSku = userProgram.programSku {
                    if let program = StorageDataManager.shared.getProgramBySku(sku: programSku) {
                        programsWithDetails.append(program)
                    }
                }
            }
        }
        
        for programWithDetails in programsWithDetails {
            let workouts = programWithDetails.workouts
            for workout in workouts {
                if workout?.dateString.toDateIgnoreAnyTimeZone() == currentDate {
                    if workout?.id != nil {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func getSelectedWave(selectedProgram: ProgramDataModel, selectedWorkout: WorkoutDataModel) -> WaveDataModel? {
        for userProgram in (StorageDataManager.shared.userPrograms ?? []) {
            if userProgram.programSku == selectedProgram.sku {
                let selectedWaveId = userProgram.selectedWave
                let waves = selectedProgram.programWaves
                for wave in waves {
                    if wave.id == selectedWaveId {
                        return wave
                    }
                }
            }
        }
        return nil
    }
    
    func getTodayWorkoutForProgram(selectedProgram: ProgramDataModel) -> WorkoutDataModel? {
        guard let currentDate = Date().toDateIgnoreAnyTimeZone()?.toString() else { return nil }
        
        for workout in selectedProgram.workouts {
            if workout?.dateString == currentDate, workout?.id != nil {
                return workout
            }
        }
        
        return nil
    }
    
    
}
