//
//  SuccessfullPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol SuccessfullPresenterProtocol: AnyObject {
    
    var view: SuccessfullVCProtocol! { get set }

    var titleText: String { get }
    var descriptionText: String { get }
    
    var nextButtonTitle: String { get }
    
    func btnNextTapped()
}
