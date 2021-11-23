//
//  VerificationCodeVCProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol VerificationCodeVCProtocol: AnyObject {
    
    func cleanupEnteredCode()
    
    func hideKeyboard()

    func popVC()
}
