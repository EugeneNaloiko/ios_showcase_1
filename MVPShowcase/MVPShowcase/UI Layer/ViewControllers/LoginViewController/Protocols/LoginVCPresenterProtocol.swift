//
//  LoginVCPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol LoginVCPresenterProtocol: AnyObject {
    var view: LoginVCProtocol! { get set }
    
    func btnNextTapped(email: String, password: String)
    func btnForgotYourPasswordTapped()
    func btnNewUserTapped()
}
