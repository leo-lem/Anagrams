// Created by Leopold Lemmermann on 15.02.25.

import Dependencies
import Foundation

public struct Words: Sendable {
  public var new: @Sendable (Locale.Language) -> String
  public var exists: @MainActor @Sendable (String, Locale.Language) -> Bool
}

extension Words {
  static let words: [Locale.Language: [String]] = {
    Dictionary(Locale.Language.supported.map { language in
      if let code = language.languageCode?.identifier,
         let url = Bundle.module.url(forResource: code, withExtension: "json"),
         let data = try? Data(contentsOf: url),
         let json = try? JSONSerialization.jsonObject(with: data, options: []),
         let words = json as? [String] {
        return (language, words)
      } else {
        assertionFailure("Missing language file: \(language)")
        return (language, [])
      }
    }) { _, strings in
      strings
    }
  }()
}
