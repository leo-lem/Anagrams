// Created by Leopold Lemmermann on 15.02.25.

import Dependencies
import SwiftData

extension DependencyValues {
  var data: SwiftDatabase {
    get { self[SwiftDatabase.self] }
    set { self[SwiftDatabase.self] = newValue }
  }
}

struct SwiftDatabase: Sendable {
  var context: @MainActor @Sendable () throws -> ModelContext

  /// configure the container here.
  @MainActor static var container: ModelContainer?
}

extension SwiftDatabase: DependencyKey {
  public static let liveValue = SwiftDatabase(
    context: {
      guard let container else { fatalError("Configure the `SwiftDatabase.ModelContainer` first!") }
      return container.mainContext
    }
  )
}
