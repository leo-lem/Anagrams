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
    
    private func addWord() { viewModel.addWord() }
    private func beginNewGame(_ saveScore: Bool) {
        viewModel.beginNewGame(saveScore: saveScore)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                Link(destination: URL(string: "https://en.wiktionary.org/wiki/\(viewModel.rootWord)") ?? URL(string: "https://en.wiktionary.org/wiki/")!) {
                    Text(viewModel.rootWord)
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                }
                
                TextField("Enter your word", text: $viewModel.newWord, onCommit: addWord)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .autocapitalization(.none)
                
                if viewModel.showError {
                    Text("\(viewModel.error)")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .border(.foreground , width: 5)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .animation(.default, value: viewModel.showError)
                }
                
                List(viewModel.usedWords, id: \.self) { word in
                    Link(destination: URL(string: "https://en.wiktionary.org/wiki/\(word)")!) {
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                    .accessibilityElement()
                    .accessibilityLabel("\(word), \(word.count) letters")
                }
            }
            .disabled(viewModel.timerEnabled ? viewModel.timeRemaining! <= 0 : false)
            .overlay(alignment: .bottom) {
                HStack {
                    Text("Your score is \(viewModel.score).")
                        .padding()
                        .font(.headline)
                    Spacer()
                        if viewModel.timerEnabled {
                            Text("You have \(viewModel.timeRemaining!) second(s) left")
                                .padding()
                                .font(.headline)
                                .onReceive(timer) { _ in
                                    if viewModel.timeRemaining! > 0 { viewModel.timeRemaining! -= 1 }
                                }
                                .onTapGesture { viewModel.timerEnabled = false }
                                .alert("Time's Up!", isPresented: $viewModel.showTimeUpAlert) {
                                    Button("OK", role: .cancel) {}
                                }
                        } else {
                            Button {
                                viewModel.timerEnabled = true
                            } label: {
                                Text(viewModel.timerEnabled ? "Deactivate Timer" : "Activate Timer")
                                Image(systemName: "clock.arrow.circlepath")
                            }
                            .padding()
                            .font(.headline)
                            .foregroundColor(.primary)
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("New Game") { viewModel.showScoreSaveDialog = true }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Highscores") {
                        RankingView(ranking: $viewModel.ranking)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showScoreSaveDialog) {
                VStack {
                    NewGameView(score: viewModel.score,
                                username: $viewModel.username,
                                rootWord: $viewModel.rootWord,
                                timeLimit: $viewModel.wrappedTimeLimit,
                                beginNewGame: beginNewGame)
                    Divider()
                    RankingView(ranking: $viewModel.ranking)
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
