//
//  ProfileViewProtocol.swift
//
//  Created by Eugene Naloiko.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    func openSafari(url: URL)
    func updateProfileImage(image: UIImage)
    func updateFullName(firstName: String, lastName: String)
}
