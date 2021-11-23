//
//  UITextField + Extensions.swift
//
//  Created by Eugene Naloiko
//

import UIKit

extension UITextField {
    
    func isBackSpaceWasPressed() -> Bool {
        let char = self.text?.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            return true
        } else {
            return false
        }
    }

    
}
