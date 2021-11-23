//
//  BasePresenter.swift
//
//  Created by Eugene Naloiko.
//

import Foundation

class BasePresenter {
    
    deinit {
        #if DEBUG
        print("Was deinited -----> \(String(describing: type(of: self)))")
        #endif
    }
    
}
