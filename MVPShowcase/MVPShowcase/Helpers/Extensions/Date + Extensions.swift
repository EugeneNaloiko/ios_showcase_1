//
//  Date + Extensions.swift
//
//  Created by Eugene Naloiko
//


import Foundation

//default date format "YYYY-MM-dd"

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    
    func toString(dateFormat: String = "YYYY-MM-dd") -> String {
        //MM-dd-YYYY
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func getCurrentAge() -> Int {
        let now = Date()
        let birthday: Date = self
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year ?? 0
        return age
    }
    
    func get(_ component: Calendar.Component, ignoreCurrentTimeZone: Bool) -> Int {
        var calendar = Calendar.current
        if ignoreCurrentTimeZone {
            calendar.timeZone = TimeZone(abbreviation: "UTC")!
        }
        return calendar.component(component, from: self)
    }
    
    func isPreviousDay() -> Bool {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        guard let datenow = Date().toDateIgnoreAnyTimeZone() else { return false }
        
        let order = calendar.compare(datenow, to: self, toGranularity: .day)
        let isPreviousDay = order == .orderedDescending
        return isPreviousDay
    }
    
    func isCurrentDay() -> Bool {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        guard let datenow = Date().toDateIgnoreAnyTimeZone() else { return false }
        
        let order = calendar.compare(datenow, to: self, toGranularity: .day)
        let isCurrentDay = order == .orderedSame
        return isCurrentDay
    }
    
    func isFutureDay() -> Bool {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        guard let datenow = Date().toDateIgnoreAnyTimeZone() else { return false }
        
        let order = calendar.compare(datenow, to: self, toGranularity: .day)
        let isFutureDay = order == .orderedAscending
        return isFutureDay
    }
    
    func toDateIgnoreAnyTimeZone(dateFormat: String = "YYYY-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: self)
        let convertedDate = dateString.toDateIgnoreAnyTimeZone()
        return convertedDate
    }
    
    func isYesterday() -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let dateNow = Date()
        guard let date = calendar.date(byAdding: .day, value: -1, to: dateNow) else { return false }
        let order = calendar.compare(self, to: date, toGranularity: .day)
        let isYesterday = order == .orderedSame
        return isYesterday
    }
    
    func isTomorrowDay() -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let dateNow = Date()
        guard let date = calendar.date(byAdding: .day, value: 1, to: dateNow) else { return false }
        let order = calendar.compare(self, to: date, toGranularity: .day)
        let isTomorrowDay = order == .orderedSame
        return isTomorrowDay
    }
    
    func daysTillToday() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.dateComponents([.day], from: self, to: Date()).day! + 1
    }
    
}

extension Date {
    
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
    func isInSameMonth(as date: Date, in calendar: Calendar) -> Bool {
        isEqual(to: date, toGranularity: .month, in: calendar)
    }
    
}
