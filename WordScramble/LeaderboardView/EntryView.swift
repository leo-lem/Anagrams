//
//  RankView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import SwiftUI

struct EntryView: View {
    let entry: Model.Leaderboard.Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(entry.name)")
                    .font(.headline)
                
                //TODO: fix seconds not being translated correctly
                if entry.time != nil {
                    Text("took \(entry.time!.formatted()) \(entry.time == 1 ? "second" : "seconds")")
                        .font(.subheadline)
                }
                
                Text("with '\(entry.word)' (\(entry.language))")
                    .font(.subheadline)
                
                Text("at \(entry.timestamp.formatted(date: .omitted, time: .shortened)) on \(entry.timestamp.formatted(date: .abbreviated, time: .omitted))")
                    .font(.footnote)
            }
            
            Spacer()
            
            Text("\(entry.score)").font(.title).bold()
        }
    }
}

struct RankView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: Model.Leaderboard.Entry.example)
    }
}
