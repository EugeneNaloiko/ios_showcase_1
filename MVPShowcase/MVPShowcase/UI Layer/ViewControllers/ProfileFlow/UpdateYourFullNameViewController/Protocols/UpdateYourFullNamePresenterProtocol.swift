//
//  UpdateYourFullNamePresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol UpdateYourFullNamePresenterProtocol: AnyObject {
    var view: UpdateYourFullNameVCProtocol! { get set }
    
    var isNavigationBarTransparent: Bool { get }
    var navigationTitle: String? { get }
    var titleText: String { get }
    var descriptionText: String { get }
    
    var nextButtonTitle: String { get }
    
    var isLogoHidden: Bool { get }
    
    func getFullName() -> (firstName: String, lastName: String)
    
    func firstNameChangedTo(newFirstName: String)
    
    func lastNameChangedTo(newLastName: String)
    
    func btnNextTapped()
}
