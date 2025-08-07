//  Created by Leopold Lemmermann on 16.01.22.

import Dependencies
import SwiftUIExtensions
import SwiftUI

public struct WordList: View {
  let words: [String]

  public var body: some View {
    List {
      ForEach(words, id: \.self) { word in
        AsyncButton {
          await open(Bundle.main[url: "DictionaryUrl"].appending(component: word))
        } label: {
          Label(word, systemImage: "\(word.count).circle")
        }
        .labelStyle(.external(color: .white, transfer: true))
        .foregroundStyle(.primary)
        .font(.headline)
      }

      if words.isEmpty {
        Text(.placeholder)
          .foregroundStyle(.secondary)
      }
    }
  }

  @Dependency(\.openURL) var open

  init(_ words: [String]) {
    self.words = words
  }
}

#Preview {
  WordList(["test", "test2"])
}

#Preview("Empty") {
  WordList([])
}
