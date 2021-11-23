//
//  ScheduleContentVCProtocol.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

protocol ScheduleContentVCProtocol: AnyObject {
    var presenter: ScheduleContentVCPresenterProtocol! { get set }
    
    func reloadTableView()
    func scrollToTheFirstRow()
}
