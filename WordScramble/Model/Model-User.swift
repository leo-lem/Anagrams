//
//  User.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import Foundation

extension Model {
    class User: ObservableObject {
        let defaults = UserDefaults.standard
        
        @Published var name = ""
        @Published var language: SupportedLanguage = .english
        @Published var timer = true
        @Published var timelimit = 5
        
        var startword = ""
        
        init() { load() }
    }
}

extension Model.User: PersistentStorage {
    func save() {
        defaults.set(name, forKey: "user.name")
        defaults.set(language.rawValue, forKey: "user.language")
        defaults.set(timelimit, forKey: "user.timelimit")
        defaults.set(timer, forKey: "user.timer")
    }
    
    func load() {
        self.name = defaults.object(forKey: "user.name") as? String ?? self.name
        self.timer = defaults.object(forKey: "user.timer") as? Bool ?? self.timer
        self.timelimit = defaults.object(forKey: "user.timelimit") as? Int ?? self.timelimit
        
        if let language = defaults.object(forKey: "user.language") as? String {
            if let supportedLanguage = Model.SupportedLanguage(rawValue: language) {
                self.language = supportedLanguage
            }
        } else {
            for localization in Bundle.main.preferredLocalizations {
                if let language = Model.SupportedLanguage(rawValue: localization) {
                    self.language = language
                }
            }
        }
    }
}

//MARK: a description for easy access to the properties when debugging
extension Model.User: CustomStringConvertible {
    var description: String {
        """
        ---------------
        User
            Name: \(self.name)
            Language: \(self.language)
            Timelimit: \(self.timelimit)
        
            Startword: \(self.startword.isEmpty ? "<None>" : self.startword)
        ---------------
        """
    }
}
