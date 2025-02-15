// Created by Leopold Lemmermann on 15.02.25.

/// For internal use. The ModelContainer has to be initialized, though.
public struct SwiftDatabase: Sendable {
  var context: @MainActor @Sendable () throws -> ModelContext

  /// Configure the container here.
  @MainActor public static var container: ModelContainer?
}

extension SwiftDatabase: DependencyKey {
  public static let liveValue = SwiftDatabase(
    context: {
      guard let container else { fatalError("Configure the `SwiftDatabase.ModelContainer` first!") }
      return container.mainContext
    }
  )
}

extension DependencyValues {
  var data: SwiftDatabase {
    get { self[SwiftDatabase.self] }
    set { self[SwiftDatabase.self] = newValue }
  }
}
