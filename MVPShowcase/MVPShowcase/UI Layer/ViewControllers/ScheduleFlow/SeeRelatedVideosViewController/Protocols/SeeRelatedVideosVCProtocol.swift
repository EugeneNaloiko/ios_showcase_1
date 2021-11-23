//
//  SeeRelatedVideosVCProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol SeeRelatedVideosVCProtocol: AnyObject {
    
    func reloadTableView()
    func displayRelatedVideos()
    func displayNoRelatedVideosView()
}
