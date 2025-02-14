//	Created by Leopold Lemmermann on 22.11.22.

@discardableResult
public func writeError<T, E: Error>(
  to error: inout E?,
  _ throwing: () throws -> T
) rethrows -> T {
  try writeError(into: { error = $0 }, throwing: throwing)
}

@discardableResult
public func writeError<T, E: Error>(
  into writeError: (E) -> Void,
  throwing: () throws -> T
) rethrows -> T {
  do {
    return try throwing()
  } catch let caught as E {
    writeError(caught)
    throw caught
  }
}

// async variants

@_disfavoredOverload
@discardableResult
public func writeError<T, E: Error>(
  to error: inout E?,
  _ throwing: () async throws -> T
) async rethrows -> T {
  try await writeError(into: { error = $0 }, throwing: throwing)
}

@_disfavoredOverload
@discardableResult
public func writeError<T, E: Error>(
  into writeError: (E) -> Void,
  throwing: () async throws -> T
) async rethrows -> T {
  do {
    return try await throwing()
  } catch let caught as E {
    writeError(caught)
    throw caught
  }
}
