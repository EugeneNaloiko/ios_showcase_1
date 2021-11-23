//
//  SuccessfullVCProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol SuccessfullVCProtocol: AnyObject {
    func startIndicator()
    func stopIndicator()

    func popToProfileVC()
}
