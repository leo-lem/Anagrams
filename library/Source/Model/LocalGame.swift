// Created by Leopold Lemmermann on 08.08.25.

import Foundation
@_exported import SwiftData

@Model public class LocalGame: Game {
  public var timestamp: Date = Date.now

  public var root: String = "universal"
  public var language: Language = Language.english
  public var limit: Int?

  public var words = [String]()
  public var time = Int.zero

  public var score: Int { words.reduce(0) { $0 + $1.count } }
  public var count: Int { words.count }
  public var outOfTime: Bool { limit != nil && time >= limit! }
  public var countdown: String {
    max(Duration.seconds(limit.flatMap { $0 - time } ?? 0), .zero)
      .formatted(.units(width: .narrow, maximumUnitCount: 1))
  }

  public init(
    timestamp: Date = .now,
    _ root: String = "universal",
    language: Language = .english,
    limit: Int? = nil,
    words: [String] = [],
    time: Int = .zero
  ) {
    self.timestamp = timestamp
    self.root = root
    self.language = language
    self.limit = limit
    self.words = words
    self.time = time
  }
}

public extension LocalGame {
  func save(to context: ModelContext) {
    timestamp = .now
    context.insert(self)
    try? context.save()
  }
}
