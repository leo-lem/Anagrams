//
//  LeaderboardDetailView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import SwiftUI

struct EntryDetailView: View {
    let entry: Model.Leaderboard.Entry
    
    var body: some View {
        VStack {
            Group {
                Text("\(entry.name) got a score of \(entry.score)").font(.title).bold()
                Text("with '\(entry.word)' (\(entry.language))").font(.title)
                if entry.time != nil {
                    Text("in \(entry.time!.formatted()) \(entry.time == 1 ? "second" : "seconds")").font(.title2)
                }
            }
            
            List(entry.usedWords, id: \.self) { word in
                UsedWordView(word: word)
            }
            
            Text("at \(entry.timestamp.formatted(date: .omitted, time: .shortened)) on \(entry.timestamp.formatted(date: .abbreviated, time: .omitted))").padding(.bottom)
        }
    }
}

struct LeaderboardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailView(entry: .example)
    }
}
