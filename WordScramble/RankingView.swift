//
//  HighscoreView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 23.12.21.
//

import SwiftUI

struct RankingView: View {
    typealias Rank = ContentView.ViewModel.Rank
    var ranking = [Rank]()
    
    var body: some View {
        VStack {
            Text("Highscores")
                .bold()
                .font(.largeTitle)
            Form {
                ForEach(ranking.sorted().reversed(), id: \.self) { rank in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(rank.name)")
                                .font(.headline)
                            Text("with '\(rank.word)'")
                                .font(.subheadline)
                            Text("at \(rank.time.formatted(date: .omitted, time: .shortened)) on \(rank.time.formatted(date: .abbreviated, time: .omitted))")
                                .font(.footnote)
                        }
                        Spacer()
                        Text("\(rank.score)")
                            .font(.title)
                    }
                }
            }
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(ranking: [RankingView.Rank(name: "Leo", word: "mon", score: 10, time: Date()),
                              RankingView.Rank(name: "Vale", word: "cacadoo", score: 15, time: Date()-1000),
                              RankingView.Rank(name: "Leo", word: "heyyy", score: 6, time: Date()-100000)])
    }
}
