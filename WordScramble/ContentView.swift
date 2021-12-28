//
//  ContentView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 02.08.21.
//

import SwiftUI
import MyLayout

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    @FocusState private var focused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.rootword)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .linkToWiktionary(word: viewModel.rootword)
                
                TextField("Enter your word", text: $viewModel.newWord) {
                    viewModel.addWord()
                    focused = true
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                .autocapitalization(.none)
                .focused($focused, equals: true)
                
                ForEach(viewModel.gameErrors) { error in
                    GameErrorView(title: error.title, description: error.description ?? "")
                        .animation(.default, value: viewModel.gameErrors)
                }
                
                List(viewModel.usedWords, id: \.self) { word in
                    UsedWordView(word: word)
                }
            }
            .disabled(viewModel.timesUp)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("New Game") { viewModel.showingNewGameDialog = true }
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Leaderboard") {
                        LeaderboardView(entries: $viewModel.leaderboardEntries)
                    }
                    .foregroundColor(.primary)
                }
            }
            .overlay(alignment: .bottom) {
                HStack {
                    ScoreView(score: viewModel.score)
                    Spacer()
                    TimerView(enabled: $viewModel.timerEnabled,
                              time: viewModel.time, limit: viewModel.limitInSeconds)
                }
                .padding()
                .background(.bar)
            }
            .sheet(isPresented: $viewModel.showingNewGameDialog) {
                VStack {
                    SettingsView(username: $viewModel.newUsername, startword: $viewModel.newRootword,
                                 language: $viewModel.newLanguage, timelimit: $viewModel.newTimelimit) {
                        viewModel.save()
                    } newGame: {
                        viewModel.newGame()
                    } apply: {
                        viewModel.apply()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
