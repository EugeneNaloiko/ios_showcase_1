//
//  L.swift
//
//  Created by Eugene on 21.10.2019.
//  Copyright © 2019 goinstore. All rights reserved.
//

import Foundation

/**
 Recommendations:
 To Convert the Localisable Strings to strings for Google Spreadsheet - one can use:
 http://www.unit-conversion.info/texttools/replace-text/
 in combination with: https://www.convertcsv.com/csv-viewer-editor.htm
 
 The Localisation Files are stored here:
 https://docs.google.com/spreadsheets/d/1svBB27IIxFA7ezpjaHMeFfr4bBqZC2viEGslWNHJGtU/edit#gid=0
 And can be exported with Custom Export -> iOS.
 
 The Script for Exporting of Localisation is located here:
 https://script.google.com/u/1/home/projects/1hlB4o__l_Qoa7SDgwFT_cQLTy0N6RB02seFkb8sepjYAepaj2L-MrtL6/edit
 */

final class L {
    static func string(_ value: String, args: [String]? = nil) -> String {
        let stringFromLocalisation = NSLocalizedString(value, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        if let args = args {
            return String.init(format: stringFromLocalisation, arguments: args as [CVarArg])
        } else {
            return stringFromLocalisation
        }
    }
}
