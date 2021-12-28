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
        
        //TODO: Fix root word not loading properly
        @Published var root = "silkworm"
        @Published var used = [String]()
        @Published var time = 0.0
        
        init() { load() }
        
        var score: Int { used.joined(separator: "").count }
        
        var errors = [Error]() {
            didSet {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    if !self.errors.isEmpty {
                        self.errors.remove(at: 0)
                    }
                }
            }
        }
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
        self.time = user.defaults.object(forKey: "game.time") as? Double ?? self.time
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
            
            Errors: \(self.errors))
        ---------------
        """
    }
}

//MARK: different game actions
extension Model.Game {
    func addWord(_ wordToAdd: String) {
        let word = wordToAdd.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let error = checkWord(word) {
            self.errors.append(error)
        } else {
            self.used.insert(word, at: 0)
        }
    }
    
    func restart(with root: String) {
        self.root = validateRoot(root)
        self.used = [String]()
        self.time = 0
        self.errors = []
    }
}

//MARK: various helper methods
extension Model.Game {
    private func validateRoot(_ root: String) -> String {
        if root.isEmpty {
            return Model().startword
        } else if let error = checkRoot(root) {
            self.errors.append(error)
            return Model().startword
        } else {
            return root
        }
    }
    
    private func checkRoot(_ word: String) -> Error? {
        guard word.count > 5 else { return .rootTooShort }
        guard checkIfReal(word: word) else { return .rootNotReal }
        return nil
    }
    
    private func checkWord(_ word: String) -> Error? {
        guard word != self.root else { return .isRoot }
        guard word.count > 3 else { return .tooShort }
        guard !self.used.contains(word) else { return .notNew }
        guard checkIfPossible(word: word) else { return .notPossible }
        guard checkIfReal(word: word) else { return .notReal }
        return nil
    }
    
    private func checkIfPossible(word: String) -> Bool {
        self.root.checkIfContained(subword: word)
    }
    
    private func checkIfReal(word: String) -> Bool {
        word.checkIfReal(language: self.user.language.rawValue)
    }
}
