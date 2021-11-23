//
//  CurrentFitnessLevelPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol CurrentFitnessLevelPresenterProtocol: AnyObject {
    var view: CurrentFitnessLevelVCProtocol! { get set }
    
    var isNavigationBarTransparent: Bool { get }
    var navigationTitle: String? { get }
    var titleText: String { get }
    var descriptionText: String { get }
    
    var nextButtonTitle: String { get }
    
    var isLogoHidden: Bool { get }
    
    func getCurrentFitnessLevel() -> FitnessLevel?
    
    func setSelectedFitnessLevel(fitnessLevel: FitnessLevel)
    
    func btnNextTapped()
}
