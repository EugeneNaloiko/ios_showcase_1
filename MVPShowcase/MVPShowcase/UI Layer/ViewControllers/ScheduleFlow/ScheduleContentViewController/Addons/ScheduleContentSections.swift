//
//  ScheduleContentSections.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

enum ScheduleContentSections {
    /// Completed workouts for picked day
    case completedWorkouts(cells: [CompletedWorkoutsSectionDataModel])
    /// All active programs
    case activePrograms(cells: [ProgramDataModel])
}
