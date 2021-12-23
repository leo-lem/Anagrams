//
//  ContentView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 02.08.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    private func addWord() { viewModel.addWord() }
    private func newGame(_ name: String, _ saveScore: Bool, _ newRootWord: String) {
        viewModel.newGame(name: name, saveScore: saveScore, newRootWord: newRootWord)
    }
    private func newGame() { viewModel.newGame() }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.rootWord)
                    .bold()
                    .font(.largeTitle)
                    .onTapGesture {
                        
                    }
                
                TextField("Enter your word", text: $viewModel.newWord, onCommit: addWord)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .autocapitalization(.none)
                
                List(viewModel.usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                    .accessibilityElement()
                    .accessibilityLabel("\(word), \(word.count) letters")
                }
                
                Text("Your score is \(viewModel.score).")
                    .padding()
                    .font(.headline)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink("Highscores") { RankingView(ranking: viewModel.ranking) }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Game") { viewModel.showScoreSaveDialog = true }
                }
            }
            .sheet(isPresented: $viewModel.showScoreSaveDialog) {
                VStack {
                    NewGameView(score: viewModel.score, newGame: newGame)
                    Divider()
                    RankingView(ranking: viewModel.ranking)
                }
            }
            .alert(isPresented: $viewModel.error.show) {
                Alert(title: Text(viewModel.error.title),
                      message: Text(viewModel.error.message),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
