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
                Text("\(NSLocalizedString(entry.name, comment: ""))")
                    .font(.headline)
                
                if entry.time != nil {
                    Text("took-seconds-label \(localizeIntWithLabel(entry.time!, label: .seconds))").font(.subheadline)
                }
                
                Text("with-word-label \(entry.word) \(entry.language)")
                    .font(.subheadline)
                
                Text("date-time-label \(entry.timestamp.formatted(date: .abbreviated, time: .omitted)) \(entry.timestamp.formatted(date: .omitted, time: .shortened))")
                    .font(.footnote)
            }
            
            Spacer()
            
            VStack {
                Text("\(entry.score)").font(.title).bold()
                Text(entry.score == 1 ? "point-label" : "points-label").font(.footnote)
            }
        }
    }
}

struct RankView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: Model.Leaderboard.Entry.example)
    }
}
