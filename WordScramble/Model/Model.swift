//
//  Model.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import Foundation

class Model: ObservableObject {
    static let singleton = Model()
    
    let persistence = PersistenceController.shared
    
    let user: User, game: Game
    
    var startWords = [String]()
    var startword: String { startWords.randomElement() ?? "" }
    
    init() {
        self.user = User()
        self.game = Game(user: user)
        
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
    func fetchStartWords() -> [String] {
        enum FetchingError: Error { case file, data, decoding }
        do {
            guard let url = Bundle.main.url(forResource: "start-\(self.user.language.rawValue)", withExtension: "json") else { throw FetchingError.file }
            guard let data = try? Data(contentsOf: url) else { throw FetchingError.data }
            guard let decoded = try? JSONDecoder().decode([String].self, from: data) else { throw FetchingError.decoding}
            
            return decoded
        } catch {
            print("Couldn't retrieve start words.")
            return []
        }
    }
}

//MARK: leaderboard
extension Model {
    func addLeaderboardEntry(game: Model.Game) {
        let context = persistence.container.viewContext
        
        guard !game.user.name.isEmpty else { return }
        
        _ = Entry(context: context, game: game)
       
        persistence.saveContext()
    }
}
