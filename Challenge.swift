//
//  Challenge.swift
//  Progressus
//
//  Created by Choong Kai Wern on 14/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

class Challenge: NSObject, NSCoding {
    
    // Primary Properties
    private(set) var name: String
    private(set) var date: Date
    private(set) var goal: Int
    private(set) var started: Bool
    
    // Computed Properties
    var time: Int {
        if !started { return 0 }
        return -Int(date.timeIntervalSinceNow)
    }
    var progressPercentage: Float {
        let parseResult = Parser.parseToArray(time: time, basedOn: Parser.Format.Hour)[0]
        let progressHour = Int(parseResult.time)!
        let percentage = (Float(progressHour) / Float(goal * 24))
        return percentage
    }
    var progressPercentageString: String {
        var percentageText = "100"
        if progressPercentage < 1 {
            percentageText = String.init(format: "%.1f", progressPercentage * 100)
        }
        return percentageText
    }
    var progressDescription: String {
        let results = Parser.parseToArray(time: time, basedOn: Parser.Format.DayHour)
        return results[0].time + results[0].unit + results[1].time + results[1].unit
    }
    
    init(name: String, date: Date, goal: Int, started: Bool) {
        self.name = name
        self.date = date
        self.goal = goal
        self.started = started
    }
    
    private func set_date(_ date: Date) {
        self.date = date
        started = true
    }
    
    
    func update(at position: Int, with dict: [String:Any]) {
        for (key,value) in dict {
            switch key {
                case "goal": self.goal = value as! Int
                case "date": self.set_date(value as! Date)
                case "started": self.started = value as! Bool
            default: break
            }
        }
        Settings.updateChallenge(at: position, with: self)
    }
    
//    override var description: String {
//        return "Date: \(date), Goal: \(goal), Started: \(started)"
//    }
    
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
