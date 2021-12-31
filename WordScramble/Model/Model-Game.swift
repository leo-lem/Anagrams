//
//  ContentView-ViewModel-Game.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import Foundation

extension Model {
    class Game: ObservableObject {
        let user: User
        
        var root: String {
            willSet { objectWillChange.send() }
            didSet { user.defaults.set(root, forKey: "game.root") }
        }
        var used: [String] {
            willSet { objectWillChange.send() }
            didSet { user.defaults.set(used, forKey: "game.used") }
        }
        var time: Int {
            willSet { objectWillChange.send() }
            didSet { user.defaults.set(time, forKey: "game.time") }
        }
        
        init(user: User) {
            self.user = user
            
            self.root = user.defaults.object(forKey: "game.root") as? String ?? "universal"
            self.used = user.defaults.object(forKey: "game.used") as? [String] ?? []
            self.time = user.defaults.object(forKey: "game.time") as? Int ??  0
        }
        
        var score: Int { used.joined(separator: "").count }
    }
}

extension Model.Game: CustomStringConvertible {
    var description: String {
        """
        ---------------
        Game
            Rootword: \(self.root)
            Used Words: \(self.used)
            Score: \(self.score)
            Time: \(self.time)
        ---------------
        """
    }
}

extension Model.Game {
    func addWord(_ wordToAdd: String) throws {
        let word = wordToAdd.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        try checkWord(word)
        
        self.used.insert(word, at: 0)
    }
    
    func restart(with root: String) {
        self.root = root
        self.used = []
        self.time = 0
    }
}

extension Model.Game {
    private func checkWord(_ word: String) throws {
        guard word != self.root else { throw Model.GameError(.isRoot, word: word) }
        guard word.count > 3 else { throw Model.GameError(.tooShort, word: word) }
        guard checkIfPossible(word: word) else { throw Model.GameError(.notPossible, word: word) }
        guard !self.used.contains(word) else { throw Model.GameError(.notNew, word: word) }
        guard checkIfReal(word: word.capitalized(with: Locale(identifier: user.language.rawValue))) else {
            throw Model.GameError(.notReal, word: word)
        }
    }
    
    private func checkIfPossible(word: String) -> Bool {
        self.root.checkIfContained(subword: word)
    }
    
    private func checkIfReal(word: String) -> Bool {
        word.checkIfReal(language: self.user.language.rawValue)
    }
}
