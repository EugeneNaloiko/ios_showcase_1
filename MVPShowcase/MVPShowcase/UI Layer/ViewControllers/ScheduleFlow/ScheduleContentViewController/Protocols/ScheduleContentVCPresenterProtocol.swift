//
//  ScheduleContentVCPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol ScheduleContentVCPresenterProtocol: AnyObject {
    var view: ScheduleContentVCProtocol! { get set }
    var selectedDate: Date! { get set }
    
    func viewWillApear()
    func getSections() -> [ScheduleContentSections]
    
    func getNumberOfSections() -> Int
    func getNumberOfRows(for section: Int) -> Int
    func getCurrentSectionTypeFor(section: Int) -> ScheduleContentSections?

    func getDataModelForActiveProgramSection(indexPath: IndexPath) -> ProgramDataModel?
    func getDataModelForCompletedWorkoutsSection(indexPath: IndexPath) -> CompletedWorkoutsSectionDataModel?
    
    /// Initiate to Refresh Streaks when workout gets completed or incompleted
    var refreshStreaks: (()->())? { get set }
    
    func performMarkAsCompleteAction(program: ProgramDataModel, workout: WorkoutDataModel)
    func performMarkAsIncompleteAction(dataModel: CompletedWorkoutsSectionDataModel)
    
    func performMoveToTodayAction(programSku: String, currentPosition: Int)
    
    func performMoveToTomorrowAction(programSku: String, currentPosition: Int)
}
