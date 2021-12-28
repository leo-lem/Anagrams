//
//  SettingsView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var username: String
    @Binding var startword: String
    @Binding var language: Model.SupportedLanguage
    @Binding var timelimit: Int
    
    let save: () -> Void, newGame: () -> Void, apply: () -> Void
    
    var body: some View {
        Form {
            Section {
                TextField("Enter your name to save", text: $username)
            } header: {
                Text("Save Game to Leaderboard")
            } footer: {
                Button("Save and Start New Game", action: save)
                    .foregroundColor(username.isEmpty ? .gray : .blue)
                    .disabled(username.isEmpty)
            }
            
            Section {
                TextField("Enter root word for next game (optional)", text: $startword)
            } header: {
                Text("Start a New Game")
            } footer: {
                Button("Start New Game", action: newGame)
                    .foregroundColor(.blue)
            }
            
            Section {
                Picker("Select your language", selection: $language) {
                    ForEach(Model.SupportedLanguage.allCases, id: \.self) { language in
                        Text(language.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                HStack {
                    Text("Time Limit")
                    Spacer()
                    Text("\(timelimit)")
                    Stepper("", value: $timelimit, in: 1...60).labelsHidden()
                }
            } header: {
                Text("Preferences")
            } footer: {
                Button("Apply and Start New Game", action: apply)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(username: .constant("Leo"), startword: .constant(""),
                     language: .constant(.german), timelimit: .constant(10)) {} newGame: {} apply: {}
    }
}
