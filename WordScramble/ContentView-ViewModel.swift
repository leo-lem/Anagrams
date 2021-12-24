//
//  ContentView-ViewModel.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI
import MyOthers

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        //game stuff
        private var startWords: [String] { didSet { userDefaults.set(startWords, forKey: "startWords") } }
        @Published var rootWord: String {
            didSet {
                if rootWord.isEmpty {
                    rootWord = startWords.randomElement() ?? "silkworm"
                } else {
                    if !checkIfReal(word: rootWord) {
                        self.error = "You can't use '\(rootWord)'!\nThat's no english word."
                        rootWord = startWords.randomElement() ?? "silkworm"
                        withAnimation { self.showError = true }
                    } else if rootWord.count < 4 {
                        self.error = "You can't use '\(rootWord)'!\nIt's too short."
                        rootWord = startWords.randomElement() ?? "silkworm"
                        withAnimation { self.showError = true }
                    }
                }
                userDefaults.set(rootWord, forKey: "rootWord")
            }
        }
        @Published private(set) var usedWords: [String] { didSet { userDefaults.set(usedWords, forKey: "usedWords") } }
        @Published var newWord: String { didSet { userDefaults.set(newWord, forKey: "newWord") } }
        
        
        //timer stuff
        @Published var timerEnabled: Bool {
            willSet {
                if newValue {
                    self.timeLimit = userDefaults.object(forKey: "timeLimit") as? Double ?? 5.0
                    self.timePassed = 0
                }
            }
            didSet {
                if !timerEnabled {
                    self.timeLimit = nil
                    self.timePassed = nil
                    self.showTimeUpAlert = false
                }
                userDefaults.set(timerEnabled, forKey: "timerEnabled")
            }
        }
        var timeLimit: Double? { didSet { userDefaults.set(timeLimit, forKey: "timeLimit") } }
        var wrappedTimeLimit: Double {
            get { timeLimit ?? 0 }
            set { if self.timeLimit != nil { self.timeLimit = newValue } }
        }
        @Published var timeRemaining: Int {
            didSet {
                if timerEnabled {
                    if timeRemaining <= 0 { self.showTimeUpAlert = true }
                    timePassed! += 1
                    userDefaults.set(timeRemaining, forKey: "timeRemaining")
                }
            }
        }
        var timePassed: Int?
        @Published var showTimeUpAlert = false
        
        //error stuff
        @Published var showError = false {
            didSet {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation { self.showError = false }
                }
            }
        }
        @Published var error = ""
        
        //ranking stuff
        @Published var showScoreSaveDialog = false
        @Published var showRanking = false
        @Published private(set) var score: Int { didSet { userDefaults.set(score, forKey: "score") } }
        @Published var ranking: [Rank] { didSet { userDefaults.setObject(ranking, forKey: "ranking") } }
        @Published var username: String { didSet { userDefaults.set(username, forKey: "username")} }
        
        func beginNewGame(saveScore: Bool = false) {
            if saveScore {
                let rank = Rank(name: self.username,
                                word: self.rootWord,
                                score: self.score,
                                time: self.timePassed,
                                usedWords: self.usedWords,
                                timestamp: Date())
                ranking.append(rank)
                ranking.sort()
            }
            
            self.showScoreSaveDialog = false
            self.newWord = ""
            self.usedWords = []
            self.score = 0
            
            if timerEnabled {
                self.showTimeUpAlert = false
                self.timeRemaining = Int(self.timeLimit ?? 0)*60
                self.timePassed = 0
            }
        }
        
        struct Rank: Comparable, Codable, Hashable {
            let name: String, word: String, score: Int, time: Int?, usedWords: [String], timestamp: Date
            
            static func < (lhs: Rank, rhs: Rank) -> Bool { lhs.score < rhs.score }
        }
        
        //initialization
        private let userDefaults = UserDefaults.standard
        
        init() {
            //start words
            if let fetchedStartWords = userDefaults.object(forKey: "startWords") as? [String] {
                self.startWords = fetchedStartWords
            } else {
                do {
                    guard let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") else { throw URLError(.badURL) }
                    let startWordsString = try String(contentsOf: startWordsURL)
                    startWords = startWordsString.components(separatedBy: "\n")
                } catch {
                    print("Error: Couldn't retrieve start words from text file")
                    startWords = []
                }
            }
            
            //game
            self.score = userDefaults.object(forKey: "score") as? Int ?? 0
            self.newWord = userDefaults.object(forKey: "newWord") as? String ?? ""
            self.rootWord = userDefaults.object(forKey: "rootWord") as? String ?? "silkworm"
            self.usedWords = userDefaults.object(forKey: "usedWords") as? [String] ?? []
            
            //ranking
            self.ranking = userDefaults.getObject(forKey: "ranking", castTo: [Rank].self) ?? [Rank]()
            self.username = userDefaults.object(forKey: "username") as? String ?? ""
            
            //timer
            self.timeLimit = nil
            self.timeRemaining = userDefaults.object(forKey: "timeRemaining") as? Int ?? Int(timeLimit ?? 5)*60
            self.timePassed = nil
            self.timerEnabled = userDefaults.object(forKey: "timerEnabled") as? Bool ?? false
            
            if timerEnabled {
                self.timePassed = 0
                self.timeLimit = userDefaults.object(forKey: "timeLimit") as? Double ?? 5.0
            }
        }
    }
}

//MARK: Validating and adding the typed word
extension ContentView.ViewModel {
    func addWord() {
        let word = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let error = validateWord(word) {
            self.error = error
            withAnimation { self.showError = true }
        } else {
            usedWords.insert(word, at: 0)
            score += word.count
        }
        self.newWord = ""
    }
    
    private func validateWord(_ word: String) -> String? {
        guard word != rootWord else {
            return "Word = root word!\nObviously you can't just use the original word"
        }
        guard word.count > 2 else {
            return "Word too short!\nOnly words with more than 2 letters allowed"
        }
        guard !usedWords.contains(word) else {
            return "Word already used!\nBe more original..."
        }
        guard checkIfPossible(word: word) else {
            return "Illegal word!\nYou can't just use any word, you know."
        }
        guard checkIfReal(word: word) else {
            return "Unknown Word!\nThat is no english word."
        }
        return nil
    }
    
    private func checkIfPossible(word: String) -> Bool {
        var chars = rootWord
        
        for char in word {
            if chars.contains(char) {
                if let index = chars.firstIndex(of: char) {
                    chars.remove(at: index)
                }
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func checkIfReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}
