//
//  UsedWordView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI

struct UsedWordView: View {
    let word: String
    
    var body: some View {
        HStack {
            Image(systemName: "\(word.count).circle")
            Text(word)
            Spacer()
        }
        .font(.headline)
        .linkToWiktionary(word: word)
        .foregroundColor(.primary)
        .accessibilityElement()
        .accessibilityLabel("\(word), \(word.count) letters")
        .accessibilityHint("Click to go to this words' wiktionary page.")
    }
}

struct UsedWordView_Previews: PreviewProvider {
    static var previews: some View {
        UsedWordView(word: "silk")
    }
}
