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
        private var startWords: [String] {
            didSet { UserDefaults.standard.set(startWords, forKey: "startWords") }
        }
        @Published private(set) var rootWord = "silkworm" {
            didSet { UserDefaults.standard.set(rootWord, forKey: "rootWord") }
        }
        @Published private(set) var usedWords = [String]() {
            didSet { UserDefaults.standard.set(usedWords, forKey: "usedWords") }
        }
        @Published var newWord = ""
        
        //error display if the word is not valid
        @Published var error = ErrorDisplay()
        struct ErrorDisplay {
            var title = "Oops!", message = "Something went wrong...", show = false
        }
        
        //ranking stuff
        @Published var showScoreSaveDialog = false
        @Published var showRanking = false
        
        @Published private(set) var score = 0 {
            didSet { UserDefaults.standard.set(score, forKey: "score") }
        }
        
        @Published var ranking = [Rank]() {
            didSet { UserDefaults.standard.setObject(ranking, forKey: "ranking") }
        }
        
        func newGame(name: String = "", saveScore: Bool = false, newRootWord: String = "") {
            if saveScore {
                let rank = Rank(name: name, word: rootWord, score: self.score, time: Date())
                ranking.append(rank)
                ranking.sort()
            }
            showScoreSaveDialog = false
            
            newWord = ""
            usedWords = []
            score = 0
            rootWord = newRootWord.isEmpty ? (startWords.randomElement() ?? rootWord) : newRootWord
        }
        
        struct Rank: Comparable, Codable, Hashable {
            let name: String, word: String, score: Int, time: Date
            
            static func < (lhs: Rank, rhs: Rank) -> Bool {
                lhs.score < rhs.score
            }
        }
        
        //loading the start words during initialization
        init() {
            if let fetchedStartWords = UserDefaults.standard.object(forKey: "startWords") as? [String] {
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
            
            self.rootWord = UserDefaults.standard.object(forKey: "rootWord") as? String ?? rootWord
            self.usedWords = UserDefaults.standard.object(forKey: "usedWords") as? [String] ?? usedWords
            self.ranking = UserDefaults.standard.getObject(forKey: "ranking", castTo: [Rank].self) ?? [Rank]()
        }
    }
}

//MARK: Validating and adding the typed word
extension ContentView.ViewModel {
    func addWord() {
        let word = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let errorDisplay = validateWord(word) {
            self.error = errorDisplay
        } else {
            usedWords.insert(word, at: 0)
            score += word.count
        }
        self.newWord = ""
    }
    
    private func validateWord(_ word: String) -> ErrorDisplay? {
        guard word != rootWord else {
            return ErrorDisplay(title: "Word = root word!", message: "Obviously you can't just use the original word", show: true)
        }
        guard word.count > 2 else {
            return ErrorDisplay(title: "Word too short!", message: "Only words with more than 2 letters allowed", show: true)
        }
        guard !usedWords.contains(word) else {
            return ErrorDisplay(title: "Word used already!", message: "Be more original...", show: true)
        }
        guard checkIfPossible(word: word) else {
            return ErrorDisplay(title: "Word not recognized!", message: "You can't just make them up, you know!", show: true)
        }
        guard checkIfReal(word: word) else {
            return ErrorDisplay(title: "Word not possible!", message: "That is no english word!", show: true)
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
