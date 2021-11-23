//
//  HomeRouter.swift
//
//  Created by Eugene Naloiko
//

import UIKit

//MARK: - HomeRouter Delegate Protocol
protocol HomeRouterDelegateProtocol: AnyObject {
    
}

//MARK: - HomeRouter Protocol
protocol HomeRouterProtocol: RouterProtocol {
    var navigationController: BaseNavigationController! { get }
    var delegate: HomeRouterDelegateProtocol? { set get }
    
    init(networkManager: NetworkManagerProtocol, navigationController: BaseNavigationController)
    
    func showWorkoutCategoriesViewController(workoutCategories: [WorkoutCategoriesDataModel])
    func showWorkoutCategoriesProgramViewController(selectedCategory: WorkoutCategoriesDataModel)
    func showProgramOverviewViewController(selectedProgram: ProgramDataModel)
}

//MARK: - HomeRouter
class HomeRouter: HomeRouterProtocol {
    var navigationController: BaseNavigationController!
    weak var delegate: HomeRouterDelegateProtocol?
    weak var networkManager: NetworkManagerProtocol!
    var programsRouter: ProgramsRouterProtocol!
    
    required init(networkManager: NetworkManagerProtocol, navigationController: BaseNavigationController) {
        self.navigationController = navigationController
        self.networkManager = networkManager
        self.programsRouter = ProgramsRouter(networkManager: networkManager, navigationController: navigationController)
    }
    
    func showWorkoutCategoriesViewController(workoutCategories: [WorkoutCategoriesDataModel]) {
        self.programsRouter.showWorkoutCategoriesViewController(workoutCategories: workoutCategories)
    }
    
    func showWorkoutCategoriesProgramViewController(selectedCategory: WorkoutCategoriesDataModel) {
        self.programsRouter.showWorkoutCategoriesProgramViewController(selectedCategory: selectedCategory)
    }
    
    func showProgramOverviewViewController(selectedProgram: ProgramDataModel) {
        self.programsRouter.showProgramOverviewViewController(selectedProgram: selectedProgram)
    }
    
}
