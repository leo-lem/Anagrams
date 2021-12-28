//
//  SettingsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import SwiftUI

struct SettingsView: View {
    @Binding private var username: String
    @Binding private var startword: String
    @Binding private var language: Model.SupportedLanguage
    @Binding private var timelimit: Int
    
    private let initialUsername: String,
                initialStartword: String,
                initialLanguage: Model.SupportedLanguage,
                initialTimelimit: Int
    
    private let save: () -> Void, newGame: () -> Void, apply: () -> Void
    
    var body: some View {
        Form {
            Section {
                TextField("Enter your name to save", text: $username)
            } header: {
                Text("Save Game to Leaderboard")
            } footer: {
                Button("Save and Start New Game", action: save)
            }
            
            Section {
                TextField("Enter root word for next game (optional)", text: $startword)
            } header: {
                Text("Start a New Game")
            } footer: {
                Button("Start New Game", action: newGame)
            }
            
            Section {
                Picker("Select your language", selection: $language) {
                    ForEach(Model.SupportedLanguage.allCases, id: \.self) { language in
                        Text(language.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                Stepper("Set time limit", value: $timelimit)
            } header: {
                Text("Preferences")
            } footer: {
                Button("Apply and Start New Game", action: apply)
                .disabled(language == initialLanguage && timelimit == initialTimelimit)
            }
        }
    }
}

extension SettingsView {
    init(username: Binding<String>,
         startword: Binding<String>,
         language: Binding<Model.SupportedLanguage>, timelimit: Binding<Int>,
         save: @escaping () -> Void, newGame: @escaping () -> Void, apply: @escaping () -> Void) {
        
        self.initialUsername = username.wrappedValue
        self.initialStartword = startword.wrappedValue
        self.initialLanguage = language.wrappedValue
        self.initialTimelimit = timelimit.wrappedValue
        
        self._username = username
        self._startword = startword
        self._language = language
        self._timelimit = timelimit
        self.save = save
        self.newGame = newGame
        self.apply = apply
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(username: .constant("Leo"), startword: .constant(""),
                     language: .constant(.german), timelimit: .constant(10)) {} newGame: {} apply: {}
    }
}
