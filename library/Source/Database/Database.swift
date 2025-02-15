// Created by Leopold Lemmermann on 15.02.25.

public struct Database<T: PersistentModel>: Sendable {
  public var fetch: @MainActor @Sendable (FetchDescriptor<T>) async throws -> [T]
  public var add: @MainActor @Sendable (T) async throws -> Void
  public var delete: @MainActor @Sendable (T) async throws -> Void
}

extension Database {
  static var implementation: Database<T> {
    Database<T>(
      fetch: { descriptor in
        @Dependency(\.data.context) var context
        return try context().fetch(descriptor)
      },
      add: { model in
        @Dependency(\.data.context) var getContext
        try getContext().insert(model)

      },
      delete: { model in
        @Dependency(\.data.context) var context
        try context().delete(model)
      }
    )
  }
}
