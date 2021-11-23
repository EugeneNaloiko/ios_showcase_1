//
//  HomeViewControllerPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol HomeViewControllerPresenterProtocol: AnyObject {
    var view: HomeViewControllerProtocol! { get set }
    
    func viewDidLoad()
    
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    
    func getCurrentSectionTypeFor(section: Int) -> HomeViewControllerSection
    
    func userInfoDetail() -> UserProfileModel?
    
    func btnGoToProfileTapped()
    func btnViewScheduleTapped()
    
    func getTodayPrograms() -> [ProgramDataModel]
    func getWorkoutCategoriesSectionDataModel() -> [WorkoutCategoriesDataModel]
    func getTrendingSectionDataModel() -> [TrendingModel]
    func getRecommendedTrainingSectionDataModel() -> [ProgramDataModel]
    func seeAllCategoriesTapped()
    
    func btnStartProgramFromWelcomeViewTapped()
    
    func todayProgramDidSelect(selectedProgram: ProgramDataModel)
    func workoutCategoryDidSelect(selectedCategory: WorkoutCategoriesDataModel)
    func trendingProgramDidSelect(selectedTrending: TrendingModel)
    func recomendedTrainingProgramDidSelect(selectedProgram: ProgramDataModel)
    
    func btnSkipTodayTapped()
}
