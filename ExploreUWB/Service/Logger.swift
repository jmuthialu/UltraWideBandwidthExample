//
//  Logger.swift
//  ExploreUWB
//
//  Created by Jay Muthialu on 11/12/21.
//

import Foundation

class Logger {
    
    enum LoggingTag: String {
        case nearby
    }
    
    static func log(tag: LoggingTag?, message: String) {
        var printString = message
        let separator = ": "
        if let tag = tag {
            printString = tag.rawValue + separator + message
        }
        print(printString)
        
    }
}
