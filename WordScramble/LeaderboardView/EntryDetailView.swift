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
                Text("name-score-label \(NSLocalizedString(entry.name, comment: "")) \(localizeIntWithLabel(entry.score, label: .points))").font(.title).bold()
                
                Text("with-word-label \(entry.word) \(entry.language)").font(.title)
                
                if entry.time != nil {
                    Text("in-seconds-label \(localizeIntWithLabel(entry.time!, label: .seconds))").font(.title2)
                }
            }
            
            List(entry.usedWords, id: \.self) { word in
                UsedWordView(word: word)
            }
            
            Text("date-time-label \(entry.timestamp.formatted(date: .abbreviated, time: .omitted)) \(entry.timestamp.formatted(date: .omitted, time: .shortened))").padding(.bottom)
        }
    }
}

struct LeaderboardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailView(entry: .example)
    }
}
