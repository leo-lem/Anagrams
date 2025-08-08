// Created by Leopold Lemmermann on 07.08.25.

import Model

@MainActor
extension LocalGame {
  static let example = LocalGame(
    "hello",
    language: .english,
    limit: 120,
    words: ["hell", "ell", "lo", "he", "ll", "hel"],
    time: .random(in: 0...120)
  )
}
