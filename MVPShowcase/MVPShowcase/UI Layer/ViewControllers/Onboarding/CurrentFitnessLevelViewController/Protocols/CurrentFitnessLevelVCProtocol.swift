//
//  CurrentFitnessLevelVCProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol CurrentFitnessLevelVCProtocol: AnyObject {
    func startIndicator()
    func stopIndicator()
    
    func popVC()
}
