//
//  HighscoreView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI

struct LeaderboardView: View {
    let entries: [Model.Leaderboard.Entry]
    
    let deleteEntries: (_ offsets: IndexSet) -> Void
    
    func delete(at offsets: IndexSet) {
        deleteEntries(offsets)
    }
    
    var body: some View {
        VStack {
            Text("Leaderboard").font(.largeTitle).bold()
            
            List {
                ForEach(entries, id: \.self) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        EntryView(entry: entry)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .toolbar { EditButton() }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LeaderboardView(entries: [.example]) { _ in }
        }
    }
}
