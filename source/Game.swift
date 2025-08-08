// Created by Leopold Lemmermann on 15.02.25.

import Foundation
import SwiftData

@Model class Game: Equatable {
  public var root = "universal"
  public var language: Language = Language.english
  public var limit: Double?
  public var words: [String] = []
  public var time: Double = Double.zero
  public var completedAt: Date?

  public var score: Int { words.reduce(0) { $0 + $1.count } }
  public var count: Int { words.count }
  public var isCompleted: Bool {
    (completedAt != nil) || (limit != nil && time >= limit!)
  }

  public init(
    _ root: String,
    language: Language,
    limit: Double?,
    words: [String] = [],
    time: Double = .zero,
    completedAt: Date? = nil
  ) {
    self.root = root
    self.language = language
    self.limit = limit
    self.words = words
    self.time = time
    self.completedAt = completedAt
  }
}

enum Language: Codable, Equatable, CaseIterable {
  case english, german, spanish, french

  var locale: Locale.Language {
    switch self {
    case .english: Locale.Language(identifier: "en")
    case .german: Locale.Language(identifier: "de")
    case .spanish: Locale.Language(identifier: "es")
    case .french: Locale.Language(identifier: "fr")
    }
  }
}

extension Language {
  public var localized: LocalizedStringResource {
    switch self {
    case .english: LocalizedStringResource.english
    case .german: LocalizedStringResource.german
    case .spanish: LocalizedStringResource.spanish
    case .french: LocalizedStringResource.french
    }
  }
}
