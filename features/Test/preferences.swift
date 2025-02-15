// Created by Leopold Lemmermann on 15.02.25.

import ComposableArchitecture
import Foundation
@testable import Preferences
import Testing

@MainActor struct PreferencesTest {
  @Test func startingGame() async throws {
    let language = Locale.Language.english
    let limit = Duration.seconds(60)
    let store = TestStore(
      initialState: Preferences.State(language: language, limit: limit),
      reducer: Preferences.init
    )

    await store.send(.view(.startButtonTapped))
    await store.receive {
      if case let .start(receivedLanguage, receivedLimit) = $0 {
        return receivedLanguage == language && receivedLimit == limit
      } else {
        return false
      }
    }
  }

  @Test func resumingGame() async throws {
    let store = TestStore(
      initialState: Preferences.State(language: .english, limit: .seconds(60)),
      reducer: Preferences.init
    )

    await store.send(.view(.resumeButtonTapped))
    await store.receive(\.resume)
  }

  @Test func settingLimitSeconds() async throws {
    let seconds: Int = 123
    let store = TestStore(
      initialState: Preferences.State(language: .english, limit: .seconds(60)),
      reducer: Preferences.init
    )
    
    await store.send(.view(.binding(.set(\.limitSeconds, seconds)))) {
      $0.$limit.withLock { $0 = .seconds(seconds) }
    }

    await store.send(.view(.binding(.set(\.limitSeconds, 0)))) {
      $0.$limit.withLock { $0 = nil }
    }
  }
}
