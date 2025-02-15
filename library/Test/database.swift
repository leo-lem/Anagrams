// Created by Leopold Lemmermann on 15.02.25.

@testable import Database
import Dependencies
import SwiftData
import Testing
import Types

@MainActor struct DatabaseTests {
  func database() async throws {
    try await withDependencies {
      $0.data = .liveValue
      $0.games = .liveValue
    } operation: {
      SwiftDatabase.container = try ModelContainer(
        for: SingleplayerGame.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
      )
      @Dependency(\.data.context) var getContext
      let context = try getContext()

      @Dependency(\.games.add) var add
      let game = SingleplayerGame("hello", language: .english, limit: nil)
      try await add(game)

      @Dependency(\.games.fetch) var fetch
      let games = try await fetch(FetchDescriptor(predicate: .true))
      #expect(games.count == 1)

      @Dependency(\.games.delete) var delete
      try await delete(game)
      #expect(try await fetch(FetchDescriptor(predicate: .true)).count == 0)

      try context.save()
    }
  }
}
