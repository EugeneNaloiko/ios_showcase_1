//
//  ProgramDetailsModel.swift
//
//  Created by Eugene Naloiko
//

import Foundation

//MARK: - ProgramDetails
struct ProgramDetailsModel: Codable {
    var id: Double
    var title: String?
    var thumbnail: String?
    var contentClean: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail
        case contentClean = "content_clean"
    }
}
