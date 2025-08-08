// Created by Leopold Lemmermann on 15.02.25.

@_exported import Dependencies
import UIKit

extension Words: DependencyKey {
  public static let liveValue = Words(
    new: { language in
      guard let word = words[language]?.randomElement() else {
        assertionFailure("No word for \(language)")
        return ""
      }

      return word
    },
    exists: { @MainActor word, language in
      guard let words = words[language] else {
        assertionFailure("No words for \(language)")
        return false
      }

      if words.contains(word) { return true }

      return UITextChecker()
        .rangeOfMisspelledWord(
          in: word,
          range: NSRange(location: 0, length: word.utf16.count),
          startingAt: 0,
          wrap: false,
          language: language.rawValue
        ).lowerBound == NSNotFound
    }
  )

  public static let previewValue = Words(
    new: { _ in "hello" },
    exists: { _, _ in true }
  )
}

public extension DependencyValues {
  var words: Words {
    get { self[Words.self] }
    set { self[Words.self] = newValue }
  }
}
