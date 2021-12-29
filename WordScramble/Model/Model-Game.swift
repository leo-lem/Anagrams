//
//  ContentView-ViewModel-Game.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import Foundation

extension Model {
    class Game: ObservableObject {
        var user = User()
        
        @Published var root = "universal"
        @Published var used = [String]()
        @Published var time = 0
        
        init() { load() }
        
        var score: Int { used.joined(separator: "").count }
    }
}

//MARK: loading and saving methods
extension Model.Game: PersistentStorage {
    func save() {
        user.defaults.set(root, forKey: "game.root")
        user.defaults.set(used, forKey: "game.used")
        user.defaults.set(time, forKey: "game.time")
    }
    func load() {
        self.root = user.defaults.object(forKey: "game.root") as? String ?? self.root
        self.used = user.defaults.object(forKey: "game.used") as? [String] ?? self.used
        self.time = user.defaults.object(forKey: "game.time") as? Int ?? self.time
    }
}

//MARK: a description for easy access to the properties when debugging
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

//MARK: different game actions
extension Model.Game {
    func addWord(_ wordToAdd: String) throws {
        let word = wordToAdd.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        try checkWord(word)
        
        self.used.insert(word, at: 0)
    }
    
    func restart(with root: String) {
        self.root = root
        self.used = [String]()
        self.time = 0
    }
}

//MARK: various helper methods
extension Model.Game {
    private func checkWord(_ word: String) throws {
        guard word != self.root else { throw GameError(.isRoot, word: word) }
        guard word.count > 3 else { throw GameError(.tooShort, word: word) }
        guard checkIfPossible(word: word) else { throw GameError(.notPossible, word: word) }
        guard !self.used.contains(word) else { throw GameError(.notNew, word: word) }
        guard checkIfReal(word: word.capitalized(with: Locale(identifier: user.language.rawValue))) else {
            throw GameError(.notReal, word: word)
        }
    }
    
    private func checkIfPossible(word: String) -> Bool {
        self.root.checkIfContained(subword: word)
    }
    
    private func checkIfReal(word: String) -> Bool {
        word.checkIfReal(language: self.user.language.rawValue)
    }
}
