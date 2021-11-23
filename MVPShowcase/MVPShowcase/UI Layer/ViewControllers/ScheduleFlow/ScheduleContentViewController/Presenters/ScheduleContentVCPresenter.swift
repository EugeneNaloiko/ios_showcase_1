//
//  ScheduleContentVCPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

struct ScheduleContentDataSourceModel {
    var activeProgramms: [ProgramDataModel]
    var completedProgramms: [ProgramDataModel]
}

final class ScheduleContentVCPresenter: ScheduleContentVCPresenterProtocol {
    
    private var sections: [ScheduleContentSections] = []
    
    weak var view: ScheduleContentVCProtocol!
    private var scheduleRouter: ScheduleRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    var selectedDate: Date! {
        didSet {
            self.updateCopletedWorkoutsSection()
        }
    }
    
    var refreshStreaks: (() -> Void)?
    
    init(view: ScheduleContentVCProtocol, scheduleRouter: ScheduleRouterProtocol, networkManager: NetworkManagerProtocol, selectedDate: Date) {
        self.selectedDate = selectedDate
        self.view = view
        self.scheduleRouter = scheduleRouter
        self.networkManager = networkManager
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateActiveProgramsSection), name: NSNotification.Name.userProgramsUpdated, object: nil)
    }
    
    func viewWillApear() {
        GlobalUpdateService.shared.getUserPrograms(completion: nil)
        self.getAllWorkoutExerciseProgress(completion: nil)
    }
    
    func getNumberOfSections() -> Int {
        return self.sections.count
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        let sectionName = self.sections[section]
        switch sectionName {
        case .completedWorkouts(let cells):
            return cells.count
        case .activePrograms(let cells):
            return cells.count
        }
    }
    
    func getSections() -> [ScheduleContentSections] {
        return self.sections
    }
    
    func getCurrentSectionTypeFor(section: Int) -> ScheduleContentSections? {
        if section < sections.count {
            return sections[section]
        } else {
            return nil
        }
    }
    
    func getDataModelForActiveProgramSection(indexPath: IndexPath) -> ProgramDataModel? {
        guard indexPath.section < self.sections.count else { return nil }
        
        let sectionName = self.sections[indexPath.section]
        switch sectionName {
        case .activePrograms(let cells):
            guard indexPath.row < cells.count else { return nil }
            return cells[indexPath.row]
        default:
            return nil
        }
    }
    
    func getDataModelForCompletedWorkoutsSection(indexPath: IndexPath) -> CompletedWorkoutsSectionDataModel? {
        let sectionName = self.sections[indexPath.section]
        switch sectionName {
        case .completedWorkouts(let cells):
            if indexPath.row < cells.count {
                return cells[indexPath.row]
            } else {
                return nil
            }
            
        default:
            return nil
        }
    }
    
    func performMarkAsCompleteAction(program: ProgramDataModel, workout: WorkoutDataModel) {
        assertionFailure("Stub")
    }
    
    func performMarkAsIncompleteAction(dataModel: CompletedWorkoutsSectionDataModel) {
        guard let userWorkoutHistoryId = dataModel.userWorkoutHistoryId else { return }
        
        self.networkManager.incompleteWorkout(userWorkoutHistoryId: userWorkoutHistoryId, completion: { [weak self] errorR in
            self?.getAllWorkoutExerciseProgress(completion: nil)
            self?.refreshStreaks?()
        })
    }
    
    func performMoveToTodayAction(programSku: String, currentPosition: Int) {
        print("performMoveToTodayAction, programSku: ", programSku)
        print("performMoveToTodayAction, currentPosition: ", currentPosition)
        
        guard let newReIndexDate = Date().toDateIgnoreAnyTimeZone()?.toString() else { return }
        
        let newCurrentPositionInCourse = currentPosition + 2
        
        self.updateCurrentPositionAndReIndexDateInProgram(programSku: programSku,
                                                          newReIndexDate: newReIndexDate,
                                                          newCurrentPosition: newCurrentPositionInCourse)
        
        
    }
    
    func performMoveToTomorrowAction(programSku: String, currentPosition: Int) {
        print("performMoveToTomorrowAction, programSku: ", programSku)
        print("performMoveToTomorrowAction, currentPosition: ", currentPosition)
        
        guard let newReIndexDate = Date().toDateIgnoreAnyTimeZone()?.toString().addDays(numberOfDays: 1) else { return }
        
        let newCurrentPositionInCourse = currentPosition + 2
        
        self.updateCurrentPositionAndReIndexDateInProgram(programSku: programSku,
                                                          newReIndexDate: newReIndexDate,
                                                          newCurrentPosition: newCurrentPositionInCourse)
        
    }
    
    private func updateCurrentPositionAndReIndexDateInProgram(programSku: String, newReIndexDate: String, newCurrentPosition: Int) {
        guard let userPrograms = StorageDataManager.shared.userPrograms else { return }
        for userProgram in userPrograms {
            if userProgram.programSku == programSku {
                var updateUserProgram = userProgram
                updateUserProgram.reIndexDate = newReIndexDate
                updateUserProgram.currentPositionInCourse = newCurrentPosition
                
                self.networkManager.updateUserProgram(program: updateUserProgram) { [weak self] updatedUserProgram, error in
                    print(updateUserProgram)
                    print("Stored New Position In Course")
                    self?.updateActiveProgramsSection()
                }
            }
        }
    }
    
    private func getAllWorkoutExerciseProgress(completion: (() -> Void)?) {
        self.networkManager.getAllWorkoutExerciseProgress(completion: { [weak self] dataModel, error in
            guard let sSelf = self else { return }
            sSelf.updateCopletedWorkoutsSection()
            completion?()
        })
    }
    
    private func updateCopletedWorkoutsSection() {
        
        for (index, section) in self.sections.enumerated() {
            switch section {
            case .completedWorkouts:
                self.sections.remove(at: index)
            default:
                break
            }
        }
        
        var cells: [CompletedWorkoutsSectionDataModel] = []
        
        for item in StorageDataManager.shared.allWorkoutExerciseProgress {
            var completedWorkoutsSectionDataModel = CompletedWorkoutsSectionDataModel()
            for program in StorageDataManager.shared.dashboardInfo?.allPrograms ?? [] {
                if item.programSku == program.sku {
                    if item.completionDate == selectedDate.toString() {
                        for workout in program.workouts {
                            if workout?.positionInCourse == (item.workoutPositionInProgram! - 1), item.workoutId != "TOOK_A_BREAK" {
                                completedWorkoutsSectionDataModel.program = program
                                completedWorkoutsSectionDataModel.workout = workout
                                completedWorkoutsSectionDataModel.userWorkoutHistoryId = item.id
                                cells.append(completedWorkoutsSectionDataModel)
                            }
                        }
                    }
                }
            }
        }
        self.sections.insert(.completedWorkouts(cells: cells), at: 0)
        self.view.reloadTableView()
    }
    
    @objc private func updateActiveProgramsSection() {
        
        for (index, section) in self.sections.enumerated() {
            switch section {
            case .activePrograms:
                self.sections.remove(at: index)
            default:
                break
            }
        }
        
        guard let userPrograms = StorageDataManager.shared.userPrograms,
              let dashboardInfo = StorageDataManager.shared.dashboardInfo,
              let allPrograms = dashboardInfo.allPrograms
        else { return }
        
        var activeProgramms: [ProgramDataModel] = []
        
        for program in allPrograms {
            for userProgram in userPrograms {
                if program.sku == userProgram.programSku {
                    if userProgram.pauseDate == nil {
                        activeProgramms.append(program)
                    }
                }
            }
        }
        
        self.sections.append(.activePrograms(cells: activeProgramms))
        self.view.reloadTableView()
    }
    
}

struct CompletedWorkoutsSectionDataModel {
    var program: ProgramDataModel?
    var workout: WorkoutDataModel?
    var userWorkoutHistoryId: String?
}
