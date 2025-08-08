// Created by Leopold Lemmermann on 08.08.25.

import CKClient
import Model

@MainActor
extension SharedGame {
  static let example = SharedGame(LocalGame.example, name: "example")
}
