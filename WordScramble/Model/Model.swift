//
//  Model.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import Foundation

//TODO: Figure out why these aren't properly publishing changes
class Model: ObservableObject {
    @Published var user = User()
    @Published var leaderboard = Leaderboard()
    @Published var game = Game()
    
    var startWords = [String]()
    var startword: String { startWords.randomElement() ?? "" }
    
    init() {
        game.user = user
        self.startWords = fetchStartWords()
    }
}

//MARK: supported languages
extension Model {
    enum SupportedLanguage: String, CaseIterable {
        case english = "en",
             german = "de",
             spanish = "es",
             french = "fr"
    }
}

//MARK: setting up the startwords
extension Model {
    private func fetchStartWords() -> [String] {
        enum FetchingError: Error { case file, data, decoding }
        do {
            guard let url = Bundle.main.url(forResource: "start-\(self.user.language.rawValue)", withExtension: "json") else { throw FetchingError.file }
            guard let data = try? Data(contentsOf: url) else { throw FetchingError.data }
            guard let decoded = try? JSONDecoder().decode([String].self, from: data) else { throw FetchingError.decoding}
            
            return decoded
        } catch {
            //TODO: implement proper error handling
            print("Couldn't retrieve start words.")
            return []
        }
    }
}
