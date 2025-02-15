//  Created by Leopold Lemmermann on 16.01.22.

import Dependencies
import Extensions
import SwiftUI

public struct WordList: View {
  let words: [String]

  public var body: some View {
    List {
      ForEach(words, id: \.self) { word in
        Button(word, systemImage: "\(word.count).circle") {
          Task {
            @Dependency(\.openURL) var open
            await open(Bundle.main[url: "DictionaryUrl"].appending(component: word))
          }
        }
        .labelStyle(.external(color: .white, transfer: true))
        .foregroundStyle(.primary)
        .font(.headline)
      }

      if words.isEmpty {
        Text(.localizable(.placeholder))
          .foregroundStyle(.secondary)
      }
    }
  }

  public init(_ words: [String]) {
    self.words = words
  }
}

#Preview {
  WordList(["test", "test2"])
}

#Preview("Empty") {
  WordList([])
}
