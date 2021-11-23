//
//  HomeViewControllerProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation
import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func reloadTableView()
    func startIndicatorOnProfileImageView()
    func stopIndicatorOnProfileImageView()
    func setProfileImage(imageData: Data)
    func updateUserFirstName(userFirstName: String)
}
