//
//  Calendar + Extensions.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

extension Calendar {
    
    func intervalOfWeek(for date: Date) -> DateInterval? {
        let weekInterval = dateInterval(of: .weekOfYear, for: date)
        return weekInterval
    }
    
    func startOfWeek(for date: Date) -> Date? {
        let startDate = intervalOfWeek(for: date)?.start
        return startDate
    }
    
    func daysWithSameWeekOfYear(as date: Date) -> [Date] {
        guard let startOfWeek = startOfWeek(for: date) else {
            return []
        }
        
        return (0 ... 6).reduce(into: []) { result, daysToAdd in
            result.append(self.date(byAdding: .day, value: daysToAdd, to: startOfWeek))
        }
        .compactMap { $0 }
    }
}
