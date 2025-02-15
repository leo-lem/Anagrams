// Created by Leopold Lemmermann on 15.02.25.

import ComposableArchitecture
@testable import Game
import Testing

@MainActor struct GameTest {
  @Test func saving() async throws {
    let store = TestStore(
      initialState: Singleplayer.State(root: "universal", language: .english, limit: nil),
      reducer: Singleplayer.init
    )

    await store.send(.view(.saveButtonTapped))
    await store.receive(\.save)
  }

  // TODO: more tests
}
