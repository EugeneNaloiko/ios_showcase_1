//
//  HowOldAreYouPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol HowOldAreYouPresenterProtocol: AnyObject {
    var view: HowOldAreYouVCProtocol! { get set }
    
    var isNavigationBarTransparent: Bool { get }
    var navigationTitle: String? { get }
    var titleText: String { get }
    var descriptionText: String { get }
    
    var nextButtonTitle: String { get }
    
    var isLogoHidden: Bool { get }
    
//    var userDataModel: UserInfoModel { get set }
    
    func getBirthDate() -> Date?
    
    func setBirthDateTo(dateString: String?)
    
    func btnNextTapped()
}
