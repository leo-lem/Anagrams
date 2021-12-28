//
//  Model-Game-Error.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import Foundation

//MARK: Custom Game-Error struct for handling wrong inputs
extension Model.Game {
    struct Error: Identifiable, Equatable {
        let id = UUID(), title: String, description: String?
        
        init(title: String, description: String? = nil) {
            self.title = title
            self.description = description
        }
        
        static let rootNotReal = Error(title: "Cannot be used as root word!", description: "That's no english word."),
                   rootTooShort = Error(title: "Cannot be used as root word!", description: "That's too short."),
                   timeUp = Error(title: "Time's up!", description: "You can start a new game (or disable the timer)."),
                   isRoot = Error(title: "Word = root word!", description: "Obviously you can't just use the original word"),
                   tooShort = Error(title: "Word too short!", description: "Only words with more than 3 letters allowed"),
                   notNew = Error(title: "Word already used!", description: "Be more original..."),
                   notPossible = Error(title: "Illegal word!", description: "You can't just use any word, you know."),
                   notReal = Error(title: "Unknown Word!", description: "That is no english word.")
    }
}
