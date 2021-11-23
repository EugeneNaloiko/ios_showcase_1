//
//  WorkoutInstructionalsPresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

final class WorkoutInstructionalsPresenter: BasePresenter, WorkoutInstructionalsPresenterProtocol {
    
    weak var view: WorkoutInstructionalsVCProtocol!
    weak var programsRouter: ProgramsRouterProtocol!
    
    private var currentProgram: ProgramDataModel
    private var selectedWaveDataModel: WaveDataModel
    private var selectedWorkout: WorkoutDataModel
    private var instructionals: [VideoDataModel]
    
    private var cellsArray: [VideoDataModel] = []
    
    init(view: WorkoutInstructionalsVCProtocol, programsRouter: ProgramsRouterProtocol, selectedProgram: ProgramDataModel, selectedWaveDataModel: WaveDataModel, selectedWorkout: WorkoutDataModel, instructionals: [VideoDataModel]) {
        self.currentProgram = selectedProgram
        self.selectedWaveDataModel = selectedWaveDataModel
        self.selectedWorkout = selectedWorkout
        self.instructionals = instructionals
        super.init()
        self.view = view
        self.programsRouter = programsRouter
        self.setupCells()
    }
    
    private func setupCells() {
        self.cellsArray = instructionals
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        return self.cellsArray.count
    }
    
    func getCellDataModel(indexPath: IndexPath) -> VideoDataModel {
        return self.cellsArray[indexPath.row]
    }
    
    func getSelectedWorkout() -> WorkoutDataModel {
        return self.selectedWorkout
    }
    
    func getCellInfo(indexPath: IndexPath) -> (videoInfoModel: AllMuseVideosModel?, thumbnail: String) {
        let svid = cellsArray[indexPath.row].museSvid ?? ""
        let thumbnail = cellsArray[indexPath.row].thumbnail ?? ""
        if svid != "" {
            return (StorageDataManager.shared.getDetailInfoForVideoBy(svid: svid), thumbnail)
        } else {
            return (nil, thumbnail)
        }
    }
    
}
