//	Created by Leopold Lemmermann on 08.11.22.

@discardableResult
public func mapError<T>(
  to error: Error,
  throwing: () throws -> T
) rethrows -> T {
  try mapError({ _ in error }, throwing: throwing)
}

@discardableResult
public func mapError<T>(
  _ transform: (Error) -> Error,
  throwing: () throws -> T
) rethrows -> T {
  do { return try throwing() } catch { throw transform(error) }
}

// async variants

@discardableResult
public func mapError<T>(
  to error: Error,
  throwing: () async throws -> T
) async rethrows -> T {
  try await mapError({ _ in error }, throwing: throwing)
}

@discardableResult
public func mapError<T>(
  _ transform: (Error) -> Error,
  throwing: () async throws -> T
) async rethrows -> T {
  do { return try await throwing() } catch { throw transform(error) }
}
