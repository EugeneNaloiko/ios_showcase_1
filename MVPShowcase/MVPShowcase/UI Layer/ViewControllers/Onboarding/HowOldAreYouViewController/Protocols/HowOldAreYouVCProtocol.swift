//
//  HowOldAreYouVCProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol HowOldAreYouVCProtocol: AnyObject {
    func startIndicator()
    func stopIndicator()
    
    func popVC()
}
