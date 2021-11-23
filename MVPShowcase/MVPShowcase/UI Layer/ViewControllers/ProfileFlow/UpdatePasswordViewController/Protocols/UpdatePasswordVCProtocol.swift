//
//  UpdatePasswordVCProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol UpdatePasswordVCProtocol: AnyObject {
    
    func startIndicator()
    func stopIndicator()
    
    func displayGeneralErrorWith(message: String)
}
