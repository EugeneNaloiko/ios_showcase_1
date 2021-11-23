//
//  AuthenticationModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

struct AuthenticationModel: Codable {
    var authenticationToken: String
    var refreshToken: String?
}
