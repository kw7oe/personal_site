//
//  Reminder.swift
//  Countdown
//
//  Created by Choong Kai Wern on 24/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

class Reminder: NSObject, NSCoding {
    
    var identifier: String
    var content: String
    var time: Date
    var willRepeat: Bool
    
    // Memberwise Initializer
    init(identifier: String, content: String, time: Date, willRepeat: Bool) {
        self.identifier = identifier
        self.content = content
        self.time = time
        self.willRepeat = willRepeat
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        let willRepeat = aDecoder.decodeBool(forKey: "willRepeat")
        guard let identifier = aDecoder.decodeObject(forKey: "identifier") as? String,
            let content = aDecoder.decodeObject(forKey: "content") as? String,
            let time = aDecoder.decodeObject(forKey: "time") as? Date
            else { return nil }
        
        self.init(identifier: identifier, content: content, time: time, willRepeat: willRepeat)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.identifier, forKey: "identifier")
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.time, forKey: "time")
        aCoder.encode(self.willRepeat, forKey: "willRepeat")
    }
}
