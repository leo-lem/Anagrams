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
        Text("Your score is \(score).")
            .font(.headline)
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(score: 10)
    }
}
