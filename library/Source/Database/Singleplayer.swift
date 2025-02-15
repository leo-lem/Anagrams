// Created by Leopold Lemmermann on 15.02.25.

import Types

extension Database: DependencyKey where T == SingleplayerGame {
  public static let liveValue = implementation
}
extension Database: TestDependencyKey where T == SingleplayerGame {}

public extension DependencyValues {
  var games: Database<SingleplayerGame> {
    get { self[Database<SingleplayerGame>.self] }
    set { self[Database<SingleplayerGame>.self] = newValue }
  }
}
