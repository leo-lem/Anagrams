//
//  ScoreView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import SwiftUI

struct ScoreView: View {
    let score: Int
    
    var body: some View {
        VStack {
            Text("\(score)").font(.headline)
            Text("points").font(.caption2)
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(score: 10)
    }
}
