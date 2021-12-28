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
        var time: Double { model.game.time }
        var gameErrors: [Model.Game.Error] { model.game.errors }
        var leaderboardEntries: [Model.Leaderboard.Rank] {
            get { model.leaderboard.entries }
            set { model.leaderboard.entries = newValue }
        }
        var timerEnabled: Bool {
            get { self.model.user.timer }
            set {
                objectWillChange.send()
                
                model.user.timer = newValue
                
                if self.timerEnabled {
                    self.timer = .scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        self.newTime += timer.timeInterval
                        if self.timesUp { timer.invalidate() }
                    }
                } else {
                    self.timer.invalidate()
                }
            }
        }
        
        @Published var showingNewGameDialog = false
        
        @Published var newWord = ""
        @Published var newRootword = ""
        @Published var newUsername = ""
        @Published var newLanguage: Model.SupportedLanguage = .english
        @Published var newTimelimit = 5
        
        init() {
            self.newUsername = self.model.user.name
            self.newLanguage = self.model.user.language
            self.newTimelimit = self.model.user.timelimit
        }
        
        //Timer
        @Published var timer = Timer()
        @Published var newTime = 0.0
        var timesUp: Bool { newTime > limitInSeconds }
        var limitInSeconds: Double { Double(model.user.timelimit) * 60 }
        
    }
}

extension ContentView.ViewModel {
    func addWord() {
        model.game.addWord(newWord)
        self.newWord = ""
    }
    
    func newGame() {
        model.game.restart(with: newRootword)
        self.showingNewGameDialog = false
    }
    
    func save() {
        model.user.name = self.newUsername
        model.leaderboard.saveEntry(game: model.game)
        self.newGame()
    }
    
    func apply() {
        model.user.language = newLanguage
        model.user.timelimit = newTimelimit
        self.newGame()
    }
}
