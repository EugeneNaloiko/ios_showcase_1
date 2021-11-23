//
//  Array + Extensions.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
    
    func next(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index + 1 <= self.count {
            if index + 1 == self.count {
                return nil
            } else {
                return self[index + 1]
            }
        }
        return nil
    }
    
    func prev(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index > 0 {
            return self[index - 1]
        }
        return nil
    }
}

