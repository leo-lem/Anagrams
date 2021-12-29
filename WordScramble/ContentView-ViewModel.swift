//
//  ContentView-ViewModel.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        //model properties
        private var model = Model()
        
        var rootword: String { model.game.root }
        var usedWords: [String] { model.game.used }
        var score: Int { model.game.score }
        var leaderboardEntries: [Model.Leaderboard.Entry] { model.leaderboard.entries }
        
        var timerEnabled: Bool {
            get { model.user.timer }
            set {
                objectWillChange.send()
                model.user.timer = newValue
                model.user.save()
            }
        }
        
        //rootword
        var newRootword = "" {
            willSet { objectWillChange.send() }
            didSet { newRootword = newRootword.lowercased() }
        }
        @Published var editingRootword = false
        var previousWords = [String]()
        
        //game
        private var newWord = ""
        var newWordLowercase: String {
            get { newWord.lowercased() }
            set {
                objectWillChange.send()
                newWord = newValue
            }
        }
        @Published var showingSave = false
        @Published var showingSaveAlert = false
        var gameErrors = [GameError]() {
            willSet { objectWillChange.send() }
            didSet {
                guard gameErrors.count <= 3 else {
                    gameErrors.removeFirst()
                    return
                }
                if let gameError = gameErrors.first {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        //TODO: Figure out how to add this animation from the view itself
                        withAnimation { self.gameErrors.removeAll { $0.id == gameError.id } }
                    }
                }
            }
        }
        
        //timer
        @Published var timelimit = 5
        var time = 0 {
            willSet { objectWillChange.send() }
            didSet {
                model.game.time = time
                model.game.save()
                
                guard timerEnabled else { return }
                
                if time == limitInSeconds / 2 {
                    self.gameErrors.append(GameError(.halftime))
                } else if time == limitInSeconds - 1 {
                    self.gameErrors.append(GameError(.timesUp))
                }
            }
        }
        var timesUp: Bool { time >= limitInSeconds }
        var limitInSeconds: Int { model.user.timelimit * 60 }
        
        //settings
        @Published var showingSettings = false
        var username: String {
            get { model.user.name == "unknown-user" ? "" : model.user.name }
            set {
                objectWillChange.send()
                model.user.name = newValue
                model.user.save()
            }
        }
        @Published var language: Model.SupportedLanguage = .english
        
        init() {
            self.username = self.model.user.name
            self.language = self.model.user.language
            self.timelimit = self.model.user.timelimit
            self.time = self.model.game.time
        }
    }
}

extension ContentView.ViewModel {
    func addWord() {
        do {
            try model.game.addWord(newWord)
            model.game.save()
        } catch let gameError as GameError {
            self.gameErrors.append(gameError)
        } catch { print("Unexpected Error: \(error)") }
        
        self.previousWords.removeAll()
        self.newWord = ""
    }
    
    func newGame(with rootword: String? = nil) {
        do {
            guard let root = rootword else {
                model.game.restart(with: model.startword)
                model.game.save()
                self.time = 0
                return
            }
            
            try checkRoot(root)
            
            model.game.restart(with: root)
        } catch let gameError as GameError {
            self.gameErrors.append(gameError)
        } catch { print("Unexpected Error: \(error)") }
        
        model.game.save()
        self.time = 0
    }
    
    func nextRootword() {
        self.previousWords.append(model.game.root)
        newGame()
    }
    
    func previousRootword() {
        newGame(with: previousWords.last)
        self.previousWords.removeLast()
    }
    
    func save() {
        model.user.name = self.username.isEmpty ? "unknown-user" : self.username
        model.user.save()
        model.leaderboard.addEntry(game: model.game)
        model.leaderboard.save()
    }
    
    func saveAndNextRootword() {
        save()
        nextRootword()
    }
    
    func saveAndNewGame() {
        save()
        newGame()
        self.showingSave = false
    }
    
    func applyAndNewGame() {
        model.user.language = language
        model.user.timelimit = timelimit
        model.user.save()
        
        model.startWords = model.fetchStartWords()
        newGame()
        self.showingSettings = false
    }
    
    func delete(at offsets: IndexSet) {
        model.leaderboard.entries.remove(atOffsets: offsets)
        model.leaderboard.save()
    }
}

extension ContentView.ViewModel {
    private func checkRoot(_ word: String) throws {
        guard word.count > 5 else { throw GameError(.rootTooShort, word: word) }
        guard word.capitalized(with: Locale(identifier: model.user.language.rawValue)).checkIfReal(language: model.user.language.rawValue) else {
            throw GameError(.rootNotReal, word: word)
        }
    }
}
