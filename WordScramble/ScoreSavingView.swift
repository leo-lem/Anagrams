//
//  ScoreSavingView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI

struct NewGameView: View {
    @Environment(\.dismiss) var dismiss
    let score: Int, newGame: (_ name: String, _ save: Bool, _ newRootWord: String) -> Void
    
    @State private var name = ""
    @State private var newRootWord = ""
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button("Cancel") { self.dismiss() }
                    .buttonStyle(.bordered)
                
                Spacer()
                
                if name.isEmpty {
                    Button("Don't Save") { newGame("", false, newRootWord) }
                        .buttonStyle(.bordered)
                } else {
                    Button("Save") { newGame(name, true, newRootWord) }
                        .buttonStyle(.bordered)
                }
            }
            
            Text("Save Score?")
                .bold()
                .font(.title)
            
            TextField("Enter your name:", text: $name)
                .textFieldStyle(.roundedBorder)
            
            TextField("optional: Enter word for next game", text: $newRootWord)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
    }
}

struct NewGameView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameView(score: 10) { _, _, _ in }
    }
}
