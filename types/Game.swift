// Created by Leopold Lemmermann on 15.02.25.

import Foundation
import SwiftData

@Model
public final class Game: Equatable {
  public var root = "universal"
  public var language = Locale.Language.english
  public var completedAt: Date?

//  public var limit: Duration?
//  @Transient public var limit: Duration? {
//    get { limitSeconds.map(Duration.seconds) }
//    set { limitSeconds = newValue.flatMap { Int($0.components.seconds) } }
//  }

//  public var time = Duration.seconds(0)
//  @Transient public var time: Duration {
//    get { Duration.seconds(timeSeconds) }
//    set { timeSeconds = Int(newValue.components.seconds) }
//  }

//  public var words = [String]()
//  @Transient public var words: [String] {
//    get { wordsCSV.split(separator: ",").map(String.init) }
//    set { wordsCSV = newValue.joined(separator: ",") }
//  }

//  public var score: Int { words.reduce(0) { $0 + $1.count } }

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
//    self.words = words
//    self.limit = limit
//    self.time = time
    self.completedAt = completedAt
  }
}
