//
//  UsedWordView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI
import MyCustomUI

struct UsedWordView: View {
    let word: String
    
    var body: some View {
        HStack {
            Image(systemName: "\(word.count).circle")
            Text(word)
            Spacer()
            Image(systemName: "arrowshape.turn.up.right.circle")
                .linkToWiktionary(word: word)
                .buttonStyle(.borderless)
        }
        .font(.headline)
        .foregroundColor(.primary)
    }
}

struct UsedWordView_Previews: PreviewProvider {
    static var previews: some View {
        UsedWordView(word: "silk")
    }
}
