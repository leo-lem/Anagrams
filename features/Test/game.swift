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
    await store.receive(\.complete)
  }

  @Test func startingWithCorrectWord() async throws {
    let word = "disturbance"
    let store = TestStore(
      initialState: Singleplayer.State(
        root: "universal",
        language: .english,
        limit: nil,
        newRoot: word
      ),
      reducer: Singleplayer.init
    ) { deps in
      deps.continuousClock = ImmediateClock()
      deps.words.exists = { _, _ in true }
    }

    store.exhaustivity = .off

    await store.send(.start) { state in
      state.newRoot = ""
      state.$roots.withLock { roots in
        roots = [word]
      }
    }
  }

  @Test func addingCorrectWord() async throws {
    let word = "sale"
    let store = TestStore(
      initialState: Singleplayer.State(
        root: "universal",
        language: .english,
        limit: nil,
        newWord: word
      ),
      reducer: Singleplayer.init
    ) { deps in
      deps.words.exists = { _, _ in true }
    }

    await store.send(.view(.newWordSubmitted))
    await store.receive(\.addWord) { state in
      state.newWord = ""
      state.game.words.append(word)
    }
  }

  // TODO: tests for alerts
}
