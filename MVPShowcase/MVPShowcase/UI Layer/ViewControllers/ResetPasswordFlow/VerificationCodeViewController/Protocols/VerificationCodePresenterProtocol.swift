//
//  VerificationCodePresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol VerificationCodePresenterProtocol: AnyObject {
    var view: VerificationCodeVCProtocol! { get set }
    
    var navigationTitle: String? { get }
    var titleText: String { get }
    var descriptionText: String { get }
    
    func viewDidLoad()
    func validateCode(code: String)
    
}
