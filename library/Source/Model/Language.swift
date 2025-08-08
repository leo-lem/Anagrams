// Created by Leopold Lemmermann on 08.08.25.

import Foundation

public enum Language: String, Codable, Equatable, CaseIterable, Sendable {
  case english = "en"
  case german = "de"
  case spanish = "es"
  case french = "fr"
}

public extension Language {
  var localized: String {
    Locale.current.localizedString(forIdentifier: rawValue)!
  }
}
