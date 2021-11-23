//
//  UpdatePasswordPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol UpdatePasswordPresenterProtocol: AnyObject {
    var view: UpdatePasswordVCProtocol! { get set }
    
    func btnNextTapped(newPassword: String, confirmedPassword: String)
}
