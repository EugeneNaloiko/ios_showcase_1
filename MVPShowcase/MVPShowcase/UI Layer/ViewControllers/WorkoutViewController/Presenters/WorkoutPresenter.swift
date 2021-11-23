//
//  WorkoutPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class WorkoutPresenter: BasePresenter, WorkoutPresenterProtocol {
    
    weak var view: WorkoutVCProtocol!
    weak var programsRouter: ProgramsRouterProtocol!
    private var networkManager: NetworkManagerProtocol!
    
    private var currentProgram: ProgramDataModel
    private var selectedWaveDataModel: WaveDataModel
    private var selectedWorkout: WorkoutDataModel
    var selectedDate: String
    
    private var cellsArray: [WorkoutVCCells] = []
    private var userWorkoutHistoryId: String?
    
    private var workoutDescription: String
    private var instructionals: [VideoDataModel]  = []
    private var warmUpVideos: [VideoDataModel]
    private var workoutVideos: [VideoDataModel]
    private var cooldownVideos: [VideoDataModel]
    
    private var workoutState: WorkoutState = .incomplete {
        didSet {
            self.view.changeWorkoutState()
        }
    }
    
    init(view: WorkoutVCProtocol, programsRouter: ProgramsRouterProtocol, networkManager: NetworkManagerProtocol, selectedProgram: ProgramDataModel, selectedWaveDataModel: WaveDataModel, selectedWorkout: WorkoutDataModel, selectedDate: String) {
        self.currentProgram = selectedProgram
        self.selectedWaveDataModel = selectedWaveDataModel
        self.selectedWorkout = selectedWorkout
        self.selectedDate = selectedDate
        self.workoutDescription = selectedWorkout.workoutDescription
        self.warmUpVideos = StorageDataManager.shared.getWarmUpVideosForWorkout(selectedProgram: selectedProgram, selectedWorkout: selectedWorkout)
        self.workoutVideos = StorageDataManager.shared.getWorkoutVideosForWorkout(selectedProgram: selectedProgram, selectedWorkout: selectedWorkout)
        self.cooldownVideos = StorageDataManager.shared.getCooldownVideosForWorkout(selectedProgram: selectedProgram, selectedWorkout: selectedWorkout)
        super.init()
        self.view = view
        self.programsRouter = programsRouter
        self.networkManager = networkManager
        
        self.commonInit()
        self.setupCells()
    }
    
    private func commonInit() {
        self.instructionals = StorageDataManager.shared.getInstructionalsForWorkout(
            selectedProgram: self.currentProgram,
            selectedWorkout: self.selectedWorkout)
    }
    
    private func setupCells() {
        self.cellsArray = []
        self.cellsArray.append(.emptyCell)
        
        if !self.workoutDescription.isEmpty {
            self.cellsArray.append(.overviewCell)
        }
        
        if !self.instructionals.isEmpty {
            self.cellsArray.append(.instructionalsCell)
        }
        
        var isShouldAddFollowAlongCell = false
        
        if !self.warmUpVideos.isEmpty {
            isShouldAddFollowAlongCell = true
        }
        
        if !self.workoutVideos.isEmpty {
            isShouldAddFollowAlongCell = true
        }
        
        if !self.cooldownVideos.isEmpty {
            isShouldAddFollowAlongCell = true
        }
        
        if isShouldAddFollowAlongCell {
            self.cellsArray.append(.followAllongCell)
        }
        
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }

    func getNumberOfRows(for section: Int) -> Int {
        return self.cellsArray.count
    }
    
    func getCellNameFor(indexPath: IndexPath) -> WorkoutVCCells {
        return self.cellsArray[indexPath.row]
    }
    
    func getCurrentProgramDataModel() -> ProgramDataModel {
        return self.currentProgram
    }
    
    func getSelectedWorkout() -> WorkoutDataModel {
        return self.selectedWorkout
    }
    
    func overviewDidSelect() {
        assertionFailure("STUB")
    }
    
    func instructionalsDidSelect() {
        self.programsRouter.showWorkoutInstructionalsViewController(selectedProgram: self.currentProgram,
                                                                selectedWaveDataModel: self.selectedWaveDataModel,
                                                                selectedWorkout: self.selectedWorkout,
                                                                instructionals: self.instructionals)
    }
    
    func followAlongDidSelect() {
        assertionFailure("STUB")
    }
    
    func getWorkoutState() -> WorkoutState {
        return self.workoutState
    }
    
    private func getAllWorkoutExerciseProgress(completion: (() -> Void)?) {
        self.networkManager.getAllWorkoutExerciseProgress(completion: { _, _ in
            completion?()
        })
    }
    
    func btnCompleteTapped() {
        switch self.workoutState {
        case .complete:
            print("Should call incomplete API")
            guard let userWorkoutHistoryId = self.userWorkoutHistoryId else { return }
            self.networkManager.incompleteWorkout(userWorkoutHistoryId: userWorkoutHistoryId, completion: { [weak self] errorR in
                if let _ = errorR {
                    let tryAgainAction: (() -> Void)? = { [weak self] in
                        self?.btnCompleteTapped()
                    }
                    UIUtils.displayNetworkErrorBanner(btnTryAgainTappedCompletion: tryAgainAction)
                } else {
                    self?.workoutState = .incomplete
                }
            })
        case .incomplete:
            break
        }
    }
}


enum WorkoutState {
    case complete
    case incomplete
}
