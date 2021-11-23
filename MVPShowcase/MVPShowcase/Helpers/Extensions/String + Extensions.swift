//
//  String + Extensions.swift
//
//  Created by Eugene Naloiko
//

import Foundation

extension String {
    func toDateIgnoreAnyTimeZone(dateFormat: String = "YYYY-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = dateFormat
        guard let dateFromString = dateFormatter.date(from: self) else { return nil }
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = dateFormat
            dateFormatter.string(from: dateFromString)
        return dateFromString
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    //validate Password
    func isValidCPasswordRequirements() -> Bool {
        let pwdRegex = "^((?=.*[0-9])).{6,}$"
        let pwd = NSPredicate(format: "SELF MATCHES %@", pwdRegex)
        let result = pwd.evaluate(with: self)
        return result
    }
    
    func addDays(numberOfDays: Int, dateFormat: String = "YYYY-MM-dd") -> String {
        let calendar = Calendar(identifier: .iso8601)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        guard let date = dateFormatter.date(from: self) else { return "" }
        guard let dateNew = calendar.date(byAdding: .day, value: numberOfDays, to: date) else { return "" }
        let dateString = dateNew.toString(dateFormat: dateFormat)
        return dateString
    }
        
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}
