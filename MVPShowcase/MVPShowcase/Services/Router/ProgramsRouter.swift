//
//  ProgramsRouter.swift
//
//  Created by Eugene Naloiko
//

import UIKit
//
////MARK: - ProgramsRouter Delegate Protocol
//protocol ProgramsRouterDelegateProtocol: AnyObject {
//
//}

//MARK: - ProgramsRouter Protocol
protocol ProgramsRouterProtocol: RouterProtocol {
    var navigationController: UINavigationController! { get }
    
    func showWorkoutCategoriesViewController(workoutCategories: [WorkoutCategoriesDataModel])
    func showWorkoutCategoriesProgramViewController(selectedCategory: WorkoutCategoriesDataModel)
    
    func showProgramOverviewViewController(selectedProgram: ProgramDataModel)
    
    func showWorkoutViewController(selectedProgram: ProgramDataModel, selectedWaveDataModel: WaveDataModel, selectedWorkout: WorkoutDataModel, selectedDate: String)
    func showWorkoutInstructionalsViewController(selectedProgram: ProgramDataModel, selectedWaveDataModel: WaveDataModel, selectedWorkout: WorkoutDataModel, instructionals: [VideoDataModel])
    
    func presentScheduleSeeRelatedVideosScreen(relatedVideos: [VideoDataModel])
    
}

//MARK: - ProgramsRouterProtocol
class ProgramsRouter: ProgramsRouterProtocol {
    
    weak var navigationController: UINavigationController!
    weak var networkManager: NetworkManagerProtocol!
    
    init(networkManager: NetworkManagerProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
    func showWorkoutCategoriesViewController(workoutCategories: [WorkoutCategoriesDataModel]) {
        assertionFailure("STUB")
    }
    
    func showWorkoutCategoriesProgramViewController(selectedCategory: WorkoutCategoriesDataModel) {
        assertionFailure("STUB")
    }
    
    func showProgramOverviewViewController(selectedProgram: ProgramDataModel) {
        assertionFailure("STUB")
    }
    
    func showWorkoutViewController(selectedProgram: ProgramDataModel, selectedWaveDataModel: WaveDataModel, selectedWorkout: WorkoutDataModel, selectedDate: String) {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = WorkoutViewController()
            let presenter = WorkoutPresenter(view: vc,
                                             programsRouter: sSelf,
                                             networkManager: sSelf.networkManager,
                                             selectedProgram: selectedProgram,
                                             selectedWaveDataModel: selectedWaveDataModel,
                                             selectedWorkout: selectedWorkout,
                                             selectedDate: selectedDate)
            vc.presenter = presenter
            vc.hidesBottomBarWhenPushed = true
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showWorkoutInstructionalsViewController(selectedProgram: ProgramDataModel, selectedWaveDataModel: WaveDataModel, selectedWorkout: WorkoutDataModel, instructionals: [VideoDataModel]) {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = WorkoutInstructionalsViewController()
            let presenter = WorkoutInstructionalsPresenter(view: vc,
                                                           programsRouter: sSelf,
                                                           selectedProgram: selectedProgram,
                                                           selectedWaveDataModel: selectedWaveDataModel,
                                                           selectedWorkout: selectedWorkout,
                                                           instructionals: instructionals)
            vc.presenter = presenter
            sSelf.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func presentScheduleSeeRelatedVideosScreen(relatedVideos: [VideoDataModel]) {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            let vc = SeeRelatedVideosViewController()
            let presenter = SeeRelatedVideosPresenter(view: vc,
                                                      programsRouter: sSelf,
                                                      networkManager: sSelf.networkManager,
                                                      relatedVideos: relatedVideos)
            vc.presenter = presenter
            
            let navigation = BaseNavigationController(rootViewController: vc)
            
            sSelf.navigationController.present(navigation, animated: true, completion: nil)
        }
    }
}
