//
//  WikiLink.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI

public struct WiktionaryLink: ViewModifier {
    let word: String
    private let wiktionaryLink = URL(string: "https://wiktionary.org/wiki/")!
    
    public func body(content: Content) -> some View {
        Link(destination: wiktionaryLink.appendingPathComponent(word)) {
            content
        }
    }
}

extension View {
    public func linkToWiktionary(word: String) -> some View {
        self.modifier(WiktionaryLink(word: word))
    }
}
