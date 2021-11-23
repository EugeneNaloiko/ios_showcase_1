//
//  HomeViewControllerSection.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

enum HomeViewControllerSection {
    case welcomeSection
    case todaySection(cells: [TodaySectionCell])
    case workoutCategoriesSection(cells: [WorkoutCategoriesSectionCell])
    case trendingSection(cells: [TrendingSectionCell])
    case recommendedTrainingSection(cells: [RecommendedTrainingSectionCell])
}

enum TodaySectionCell {
    case todayCell
}

enum WorkoutCategoriesSectionCell {
    case workoutCategoriesCell
}

enum TrendingSectionCell {
    case trendingSectionCell
}

enum RecommendedTrainingSectionCell {
    case recommendedTrainingSectionCell
}
