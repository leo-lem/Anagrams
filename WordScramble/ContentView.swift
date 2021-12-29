//
//  ContentView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 02.08.21.
//

import SwiftUI
import MyLayout
import MyCustomUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                RootwordView(newRootword: $viewModel.newRootword, editingRootword: $viewModel.editingRootword,
                             rootword: viewModel.rootword, isFirst: viewModel.previousWords.isEmpty) { rootword in
                    withAnimation { viewModel.newGame(with: rootword) }
                } nextWord: {
                    withAnimation {
                        viewModel.score != 0 ? viewModel.showingSaveAlert = true : viewModel.nextRootword() }
                } previousWord: {
                    withAnimation { viewModel.previousRootword() }
                }
                .alert("next-word-save-label", isPresented: $viewModel.showingSaveAlert) {
                    Button("save-label") { viewModel.saveAndNextRootword() }
                    Button("dont-save-label", role: .destructive) { viewModel.nextRootword() }
                    Button("cancel-label", role: .cancel) {}
                }
                
                Group {
                    TextField("enter-word-label", text: $viewModel.newWordLowercase) {
                        withAnimation { viewModel.addWord() }
                        self.focused = true
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .disabled(viewModel.timerEnabled && viewModel.timesUp)
                    .focused($focused)
                    
                    ForEach(viewModel.gameErrors.reversed()) { error in
                        GameErrorView(error: error)
                            .transition(.slide)
                    }.zIndex(10)
                    
                    List(viewModel.usedWords, id: \.self) { word in
                        UsedWordView(word: word)
                    }
                }
                .hidden(viewModel.editingRootword)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    SymbolButton("gear") {
                        withAnimation { viewModel.showingSettings = true }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    SymbolButton("increase.indent") {
                        withAnimation { viewModel.showingSave.toggle() }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        LeaderboardView(entries: viewModel.leaderboardEntries) { offsets in
                            withAnimation { viewModel.delete(at: offsets) }
                        }
                    } label: {
                        Image(systemName: "list.star")
                    }
                }
            }
            
            .overlay(alignment: .bottom) {
                HStack {
                    TimerView(time: $viewModel.time, limit: viewModel.limitInSeconds)
                        .onTapGesture {
                            withAnimation { viewModel.timerEnabled = false}
                        }
                        .hidden(!viewModel.timerEnabled)
                        .overlay {
                            if !viewModel.timerEnabled {
                                SymbolButton("timer") {
                                    withAnimation { viewModel.timerEnabled = true }
                                }
                                .font(.title2)
                                .disabled(viewModel.timesUp)
                                .foregroundColor(viewModel.timesUp ? .gray : .primary)
                            }
                        }
                        
                    Spacer()
                        
                    ScoreView(score: viewModel.score)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.bar)
                
            }
            
            .overlay(alignment: .top) {
                if viewModel.showingSave {
                    ZStack(alignment: .top) {
                        Color.black.opacity(0.2)
                            .onTapGesture {
                                withAnimation { viewModel.showingSave = false }
                            }
                        
                        SaveView(username: $viewModel.username) {
                            withAnimation { viewModel.saveAndNewGame() }
                        }
                        .padding(.top, 5)
                    }
                }
            }
            
            .sheet(isPresented: $viewModel.showingSettings) {
                SettingsView(language: $viewModel.language, timelimit: $viewModel.timelimit) {
                    withAnimation { viewModel.applyAndNewGame() }
                }
            }
            
            .navigationBarTitleDisplayMode(.inline)
        }
        .foregroundColor(.primary)
        .navigationViewStyle(.stack)
    }
    
    @FocusState private var focused: Bool
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
