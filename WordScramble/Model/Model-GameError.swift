//
//  Model-GameError.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 30.12.21.
//

import Foundation

extension Model {
    struct GameError: Error, Identifiable, Equatable {
        enum ErrorKind: Error {
            case rootNotReal, rootTooShort
            case halftime, timesUp
            case isRoot, tooShort, notPossible, notNew, notReal
        }
        
        let id = UUID()
        let kind: ErrorKind
        let word: String?
        
        init(_ kind: ErrorKind, word: String? = nil) {
            self.kind = kind
            self.word = word
        }
        
        static func ==(lhs: GameError, rhs: GameError) -> Bool {
            lhs.id == rhs.id
        }
    }
}
