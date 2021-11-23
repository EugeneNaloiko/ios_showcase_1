//
//  NewPasswordEnterEmailPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol NewPasswordEnterEmailPresenterProtocol: AnyObject {
    var view: NewPasswordEnterEmailVCProtocol! { get set }
    
    var imageName: String { get }
    var navigationTitle: String? { get }
    var titleText: String { get }
    var descriptionText: String { get }
    
    var nextButtonTitle: String { get }
    
    func btnNextTapped(email: String)
}
