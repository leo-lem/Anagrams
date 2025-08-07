// Created by Leopold Lemmermann on 07.08.25.

import Foundation

@MainActor
extension Game {
  static let example = Game(
    "hello",
    language: .english,
    limit: 120,
    words: ["hell", "ell"],
    time: 110,
    completedAt: .now
  )
}
