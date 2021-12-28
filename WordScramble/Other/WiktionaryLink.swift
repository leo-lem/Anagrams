//
//  WikiLink.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI

//TODO: somehow wrap objects in a link to the wiktionary page
public struct WiktionaryLink: ViewModifier {
    let word: String
    
    public func body(content: Content) -> some View {
        Link(destination: URL(string: "https://wiktionary.org/wiki/\(word)") ?? URL(string: "https://wiktionary.org/wiki/")!) {
            content
        }
    }
}

extension View {
    public func linkToWiktionary(word: String) -> some View {
        self.modifier(WiktionaryLink(word: word))
    }
}
