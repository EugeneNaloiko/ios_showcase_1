//
//  WorkoutPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol WorkoutPresenterProtocol: AnyObject {
    
    var selectedDate: String { get }
    
    func getNumberOfSections() -> Int
    func getNumberOfRows(for section: Int) -> Int
    
    func getCellNameFor(indexPath: IndexPath) -> WorkoutVCCells
    
    func getCurrentProgramDataModel() -> ProgramDataModel
    
    func getSelectedWorkout() -> WorkoutDataModel
    
    func getWorkoutState() -> WorkoutState
    
    func overviewDidSelect()
    func instructionalsDidSelect()
    func followAlongDidSelect()
    
    func btnCompleteTapped()
}

