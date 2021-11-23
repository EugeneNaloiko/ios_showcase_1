//
//  SeeRelatedVideosPresenterProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol SeeRelatedVideosPresenterProtocol: AnyObject {
    
    func getNumberOfSections() -> Int
    func getNumberOfRows(for section: Int) -> Int
    
    func getCellTitle(indexPath: IndexPath) -> String
    
    func getCellThumbnail(indexPath: IndexPath) -> String
    
    func getVideosCellInfo(indexPath: IndexPath) -> AllMuseVideosModel?
    
    func getVideoTypes(indexPath: IndexPath) -> [String]
    
}
