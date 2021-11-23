//
//  ScheduleRouter.swift
//
//  Created by Eugene Naloiko
//

import UIKit

//MARK: - ScheduleRouterProtocol
protocol ScheduleRouterProtocol: RouterProtocol {
    var navigationController: UINavigationController! { get }
    
    init(networkManager: NetworkManagerProtocol, navigationController: UINavigationController)
    
    func presentScheduleSeeRelatedVideosScreen(relatedVideos: [VideoDataModel])
    func showWorkoutViewController(selectedProgram: ProgramDataModel, selectedWaveDataModel: WaveDataModel, selectedWorkout: WorkoutDataModel, selectedDate: String)
}

//MARK: - ScheduleRouter
class ScheduleRouter: ScheduleRouterProtocol {
    var navigationController: UINavigationController!
    private var networkManager: NetworkManagerProtocol!
    var programsRouter: ProgramsRouterProtocol!
    
    required init(networkManager: NetworkManagerProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.networkManager = networkManager
        self.programsRouter = ProgramsRouter(networkManager: networkManager, navigationController: navigationController)
    }
    
    func presentScheduleSeeRelatedVideosScreen(relatedVideos: [VideoDataModel]) {
        self.programsRouter.presentScheduleSeeRelatedVideosScreen(relatedVideos: relatedVideos)
    }

    func showWorkoutViewController(selectedProgram: ProgramDataModel, selectedWaveDataModel: WaveDataModel, selectedWorkout: WorkoutDataModel, selectedDate: String) {
        self.programsRouter.showWorkoutViewController(selectedProgram: selectedProgram,
                                                      selectedWaveDataModel: selectedWaveDataModel,
                                                      selectedWorkout: selectedWorkout,
                                                      selectedDate: selectedDate)
    }
}

