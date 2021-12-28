//
//  HighscoreView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI

struct LeaderboardView: View {
    @Binding var entries: [Model.Leaderboard.Rank]
    
    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .bold()
                .font(.largeTitle)
            List {
                ForEach(entries.sorted(), id: \.self) { entry in
                    NavigationLink {
                        List(entry.usedWords, id: \.self) { word in
                            UsedWordView(word: word)
                        }
                    } label: {
                        RankView(rank: entry)
                    }
                }
                .onDelete(perform: delete)
            }
            
            
            Spacer()
        }
        .toolbar {
            EditButton()
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LeaderboardView(entries: .constant([.example]))
        }
    }
}
