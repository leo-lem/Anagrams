//
//  HighscoreView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI

struct RankingView: View {
    typealias Rank = ContentView.ViewModel.Rank
    @Binding var ranking: [Rank]
    
    func delete(at offsets: IndexSet) {
        ranking.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack {
            Text("Highscores")
                .bold()
                .font(.largeTitle)
            
            List {
                ForEach(ranking.sorted().reversed(), id: \.self) { rank in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(rank.name)")
                                .font(.headline)
                            if rank.time != nil {
                                Text("took \(rank.time!) seconds")
                                    .font(.subheadline)
                            }
                            Text("with '\(rank.word)'")
                                .font(.subheadline)
                            Text("at \(rank.timestamp.formatted(date: .omitted, time: .shortened)) on \(rank.timestamp.formatted(date: .abbreviated, time: .omitted))")
                                .font(.footnote)
                        }
                        Spacer()
                        Text("\(rank.score)")
                            .font(.title)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .toolbar {
            EditButton()
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(ranking: .constant([
            RankingView.Rank(name: "Leo", word: "monday", score: 10, time: 100, usedWords: ["day", "may", "moan"], timestamp: Date())
        ]))
    }
}
