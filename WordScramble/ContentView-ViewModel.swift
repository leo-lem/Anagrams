//
//  ContentView-ViewModel.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        private var model = Model()
        
        var rootword: String { model.game.root }
        var usedWords: [String] { model.game.used }
        var score: Int { model.game.score }
        
        var gameErrors: [Model.Game.Error] { model.game.errors }
        var leaderboardEntries: [Model.Leaderboard.Entry] { model.leaderboard.entries }
        
        var timerEnabled: Bool {
            get { model.user.timer }
            set {
                model.user.timer = newValue
                model.user.save()
            }
        }
        
        @Published var showingNewGameDialog = false
        
        @Published var newWord = ""
        @Published var newRootword = ""
        @Published var newUsername = ""
        @Published var newLanguage: Model.SupportedLanguage = .english
        @Published var newTimelimit = 5
        
        var newTime = 0.0 {
            willSet { objectWillChange.send() }
            didSet {
                model.game.time = newTime
                model.game.save()
            }
        }
        
        init() {
            self.newUsername = self.model.user.name
            self.newLanguage = self.model.user.language
            self.newTimelimit = self.model.user.timelimit
            self.newTime = self.model.game.time
        }
        
        //Timer
        var timesUp: Bool { newTime >= limitInSeconds }
        var limitInSeconds: Double { Double(model.user.timelimit) * 60 }
    }
}

extension ContentView.ViewModel {
    func addWord() {
        model.game.addWord(newWord)
        model.game.save()
        
        self.newWord = ""
    }
    
    func newGame() {
        model.game.restart(with: newRootword)
        model.game.save()
        
        self.newTime = 0.0
        self.showingNewGameDialog = false
    }
    
    func save() {
        model.user.name = self.newUsername
        model.leaderboard.addEntry(game: model.game)
        model.leaderboard.save()
        
        self.newGame()
    }
    
    func apply() {
        model.user.language = newLanguage
        model.user.timelimit = newTimelimit
        model.user.save()
        
        model.startWords = model.fetchStartWords()
        self.newGame()
    }
    
    func delete(at offsets: IndexSet) {
        model.leaderboard.entries.remove(atOffsets: offsets)
        model.leaderboard.save()
    }
}
