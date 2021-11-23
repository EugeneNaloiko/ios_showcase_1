//
//  Platform.swift
//
//  Created by Eugene Naloiko
//

import Foundation

class Platform {
    static func isValidDate(month: Int, day: Int, year: Int) -> (isValid: Bool, date: Date?) {
        var components = DateComponents()
        components.month = month
        components.day = day
        components.year = year
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        components.calendar = calendar
        
        return (components.isValidDate, components.date)
    }
}
