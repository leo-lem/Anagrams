// Created by Leopold Lemmermann on 15.02.25.

import Foundation
import SwiftData

@Model
public final class SingleplayerGame: Equatable, @unchecked Sendable {
  public var root = "universal"
  public var language = Locale.Language.english
  public var limit: Duration?
  public var time = Duration.zero
  public var _words: [String]? // swiftlint:disable:this identifier_name

  public var completedAt: Date?

  public var words: [String] {
    get { _words ?? [] }
    set { _words = newValue }
  }
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
    _words = words
    self.time = time
    self.completedAt = completedAt
  }
}
