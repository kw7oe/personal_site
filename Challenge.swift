//
//  Challenge.swift
//  Progressus
//
//  Created by Choong Kai Wern on 14/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

class Challenge: NSObject, NSCoding {
    var name: String
    var date: Date
    var goal: Int
    var started: Bool
    
    init(name: String, date: Date, goal: Int, started: Bool) {
        self.name = name
        self.date = date
        self.goal = goal
        self.started = started
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        let started = aDecoder.decodeBool(forKey: "started")
        let goal = aDecoder.decodeInteger(forKey: "goal")
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let date = aDecoder.decodeObject(forKey: "date") as? Date
            else { return nil }
        
        self.init(name: name, date: date, goal: goal, started: started)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.goal, forKey: "goal")
        aCoder.encode(self.started, forKey: "started")
    }
}
