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
        @Published private(set) var rootWord = "silkworm"
        @Published private(set) var usedWords = [String]()
        @Published var newWord = ""
        private var answer: String {
            newWord
                .lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        //error display if the word is not valid
        @Published var error = ErrorDisplay()
        class ErrorDisplay {
            var title = "Oops!", message = "Something went wrong...", show = false
        }
        
        //ranking stuff
        @Published var showScoreSaveDialog = false
        @Published var showRanking = false
        
        @Published private(set) var score = 0
        
        @Published var ranking = [Rank]() {
            didSet {
                UserDefaults.standard.setObject(ranking, forKey: "ranking")
            }
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
        private let startWords: [String]
        init() {
            do {
                guard let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") else { throw URLError(.badURL) }
                let startWordsString = try String(contentsOf: startWordsURL)
                startWords = startWordsString.components(separatedBy: "\n")
            } catch {
                print("Error: Couldn't retrieve start words from text file")
                startWords = []
            }
            newGame()
            
            self.ranking = UserDefaults.standard.getObject(forKey: "ranking", castTo: [Rank].self) ?? [Rank]()
        }
    }
}

//MARK: Validating and adding the typed word
extension ContentView.ViewModel {
    func addWord() {
        do {
            try validateWord()
            usedWords.insert(answer, at: 0)
            score += answer.count
        } catch WordError.isRootword(let title, let message) {
            self.error.title = title
            self.error.message = message
            self.error.show = true
        } catch WordError.notLongEnough(let title, let message){
            self.error.title = title
            self.error.message = message
            self.error.show = true
        } catch WordError.notOriginal(let title, let message) {
            self.error.title = title
            self.error.message = message
            self.error.show = true
        } catch WordError.notPossible(let title, let message) {
            self.error.title = title
            self.error.message = message
            self.error.show = true
        } catch WordError.notReal(let title, let message) {
            self.error.title = title
            self.error.message = message
            self.error.show = true
        } catch {
            self.error.show = true
        }
    }
    
    private enum WordError: Error {
        case isRootword(title: String = "Word = root word!", message: String = "Obviously you can't just use the original word"),
             notLongEnough(title: String = "Word too short!", message: String = "Only words with more than 2 letters allowed"),
             notOriginal(title: String  = "Word used already!", message: String = "Be more original..."),
             notPossible(title: String = "Word not recognized!", message: String = "You can't just make them up, you know!"),
             notReal(title: String = "Word not possible!", message: String = "That is no english word!")
    }
    
    private func validateWord() throws {
        guard answer != rootWord else { throw WordError.isRootword() }
        guard answer.count > 2 else { throw WordError.notLongEnough() }
        guard isOriginal else { throw WordError.notOriginal() }
        guard isPossible else { throw WordError.notPossible() }
        guard isReal else { throw WordError.notReal() }
    }
    
    private var isOriginal: Bool {
        !usedWords.contains(answer)
    }
    
    private var isPossible: Bool {
        var isPossible = true
        var chars = Array(rootWord)
        
        answer.forEach { char in
            if chars.contains(char) {
                if let index = chars.firstIndex(where: { $0 == char }) {
                    chars.remove(at: index)
                } else {
                    isPossible = false
                }
            }
        }
        
        return isPossible
    }
    
    private var isReal: Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: answer.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: answer, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}
