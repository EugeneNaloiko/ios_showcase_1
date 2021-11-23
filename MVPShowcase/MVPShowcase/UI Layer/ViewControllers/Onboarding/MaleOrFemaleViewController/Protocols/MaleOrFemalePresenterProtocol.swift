//
//  MaleOrFemalePresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol MaleOrFemalePresenterProtocol: AnyObject {
    var view: MaleOrFemaleVCProtocol! { get set }
    
    var isNavigationBarTransparent: Bool { get }
    var navigationTitle: String? { get }
    var titleText: String { get }
    var descriptionText: String { get }
    
    var nextButtonTitle: String { get }
    
    var isLogoHidden: Bool { get }
    
    func getSex() -> Sex?
    
    func setSelectedSexToProfileModel(sex: Sex)
    
    func btnNextTapped()
}
