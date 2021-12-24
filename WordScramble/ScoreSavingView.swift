//
//  ScoreSavingView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI

struct NewGameView: View {
    @Environment(\.dismiss) var dismiss
    let score: Int
    @Binding var username: String
    @Binding var rootWord: String
    @State private var newRootWord = ""
    @Binding var timeLimit: Double
    let beginNewGame: (_ save: Bool) -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("Enter your name to save", text: $username)
                .textFieldStyle(.roundedBorder)
            
            TextField("Enter root word for next game (optional)", text: $newRootWord)
                .textFieldStyle(.roundedBorder)
            
            if timeLimit != 0 {
                HStack {
                    Text("Timer")
                    Slider(value: $timeLimit, in: 1...60, step: 1)
                    Text("\(Int(timeLimit)) min")
                }
            }
            
            Button(username.isEmpty ? "New Game Without Saving" : "Save and Start New Game") {
                beginNewGame(!username.isEmpty)
                newRootWord.removeAll { $0 == " " }
                rootWord = newRootWord.lowercased()
            }
            .padding()
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct NewGameView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameView(score: 15, username: .constant("Leo"), rootWord: .constant("indigo"), timeLimit: .constant(300)) { _ in }
    }
}
