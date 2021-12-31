//
//  Entry.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 30.12.21.
//

import CoreData

@objc (Entry)
class Entry: NSManagedObject { }

extension Entry {
    //properties to read the corresponding swift values from
    var rLanguage: String { language ?? "en" }
    var rTime: Int? {
        let time = Int(time)
        return (time == -1 ? nil : time)
    }
    var rTimestamp: Date { timestamp ?? Date() }
    var rUsedWords: [String] { usedWords ?? [] }
    var rUsername: String { username ?? "unknown-user" }
    var rWord: String { word ?? "<error>" }
    var rScore: Int { Int(score)}
}

//example data for previewing
extension Entry {
    static var example: Entry {
        let entry = Entry()
        entry.username = "Leo"
        entry.word = "universal"
        entry.language = "en"
        entry.time = Int16(34)
        entry.usedWords = ["nivel", "nurse", "navel", "sail", "sailer"]
        entry.score = Int16(25)
        entry.timestamp = Date()
        
        return entry
    }
    
    static func insertExample(context: NSManagedObjectContext) {
        let entry = Entry(context: context)
        entry.username = "Leo"
        entry.word = "universal"
        entry.language = "en"
        entry.time = Int16(34)
        entry.usedWords = ["nivel", "nurse", "navel", "sail", "sailer"]
        entry.score = Int16(25)
        entry.timestamp = Date()
    }
}

//some shorthand initializers
extension Entry {
    convenience init(game: Model.Game) {
        self.init()
        
        self.username = game.user.name
        self.word = game.root
        self.language = game.user.language.rawValue
        self.time = Int16(game.user.timer ? game.time : -1)
        self.usedWords = game.used
        self.score = Int16(game.score)
        self.timestamp = Date()
    }
    
    convenience init(context: NSManagedObjectContext, game: Model.Game) {
        self.init(context: context)
        
        self.username = game.user.name
        self.word = game.root
        self.language = game.user.language.rawValue
        self.time = Int16(game.user.timer ? game.time : -1)
        self.usedWords = game.used
        self.score = Int16(game.score)
        self.timestamp = Date()
    }
}
