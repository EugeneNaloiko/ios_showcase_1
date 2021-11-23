//
//  WorkoutInstructionalsPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//
import Foundation

protocol WorkoutInstructionalsPresenterProtocol: AnyObject {
    
    func getNumberOfSections() -> Int
    func getNumberOfRows(for section: Int) -> Int
    func getCellDataModel(indexPath: IndexPath) -> VideoDataModel
    func getSelectedWorkout() -> WorkoutDataModel
    func getCellInfo(indexPath: IndexPath) -> (videoInfoModel: AllMuseVideosModel?, thumbnail: String)
}

