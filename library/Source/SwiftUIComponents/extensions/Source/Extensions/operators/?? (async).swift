// Created by Leopold Lemmermann on 08.12.22.

/// Async implementation of nil coalesce operator.
public func ?? <T>(lhs: T?, rhs: @autoclosure () async throws -> T) async rethrows -> T {
  if let lhs { return lhs } else { return try await rhs() }
}
