//
//  User.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import Foundation

//TODO: sync these settings in iCloud key-value
extension Model {
    class User: ObservableObject {
        let defaults = UserDefaults.standard
        
        var name: String {
            willSet { objectWillChange.send() }
            didSet { defaults.set(name, forKey: "user.name") }
        }
        var language: SupportedLanguage = .english {
            willSet { objectWillChange.send() }
            didSet { defaults.set(language.rawValue, forKey: "user.language") }
        }
        var timer: Bool {
            willSet { objectWillChange.send() }
            didSet { defaults.set(timer, forKey: "user.timer") }
        }
        var timelimit: Int {
            willSet { objectWillChange.send() }
            didSet { defaults.set(timelimit, forKey: "user.timelimit") }
        }
        
        init() {
            self.name = defaults.object(forKey: "user.name") as? String ?? ""
            self.timer = defaults.object(forKey: "user.timer") as? Bool ?? true
            self.timelimit = defaults.object(forKey: "user.timelimit") as? Int ?? 5
            
            loadLanguage()
        }
    }
}

extension Model.User {
    func loadLanguage() {
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

extension Model.User: CustomStringConvertible {
    var description: String {
        """
        ---------------
        User
            Name: \(self.name)
            Language: \(self.language)
            Timelimit: \(self.timelimit)
        ---------------
        """
    }
}
