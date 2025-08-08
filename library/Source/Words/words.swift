// Created by Leopold Lemmermann on 15.02.25.

import Dependencies
import Foundation
import Model

public struct Words: Sendable {
  public var new: @Sendable (Language) -> String
  public var exists: @MainActor @Sendable (String, Language) -> Bool
}

extension Words {
  static let words: [Language: [String]] = {
    Dictionary(Language.allCases.map { language in
      if let url = Bundle.module.url(forResource: language.rawValue, withExtension: "json"),
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
