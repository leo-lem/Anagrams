// Created by Leopold Lemmermann on 15.02.25.

import Foundation
import SwiftData

@Model public final class SingleplayerGame: Equatable, @unchecked Sendable {
  public var root: String
  public var language: Locale.Language
  public var limit: Duration?
  public var words: [String]
  public var time: Duration

  public var completedAt: Date?

  public var score: Int { words.reduce(0) { $0 + $1.count } }

  public init(
    _ root: String,
    language: Locale.Language,
    limit: Duration?,
    words: [String] = [],
    time: Duration = .zero,
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
