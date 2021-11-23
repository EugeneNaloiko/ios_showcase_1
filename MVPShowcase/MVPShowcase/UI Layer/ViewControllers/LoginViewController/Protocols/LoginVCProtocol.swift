//
//  LoginVCProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol LoginVCProtocol: AnyObject {
    
    func startIndicator()
    func stopIndicator()
    
    func displayGeneralErrorWith(message: String)
}
