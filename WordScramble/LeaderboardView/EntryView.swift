//
//  RankView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import SwiftUI

struct EntryView: View {
    let rank: Model.Leaderboard.Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(rank.name)")
                    .font(.headline)
                
                if rank.time != nil {
                    Text("took \(rank.time!.formatted()) \(rank.time == 1 ? "second" : "seconds")")
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
                .bold()
        }
    }
}

struct RankView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(rank: Model.Leaderboard.Entry.example)
    }
}
