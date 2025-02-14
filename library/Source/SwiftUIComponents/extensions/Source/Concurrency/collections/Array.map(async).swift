//	Created by Leopold Lemmermann on 11.11.22.

public extension Array {
  /// Asynchronously maps the array and returns the result.
  /// - Parameter transform: The transformation to apply to the array's elements.
  /// - Returns: An array of the transformed values.
  @_disfavoredOverload
  func map<T>(_ transform: @escaping (Element) async throws -> T) async throws -> [T] {
    try await map(transform).collect()
  }
  
  /// Asynchronously maps the array and streams the result (available when transform is non-throwing).
  /// - Parameter transform: The transformation to apply to the array's elements.
  /// - Returns: An AsyncStream of the transformed values.
  @_disfavoredOverload
  func map<T>(_ transform: @escaping (Element) async -> T) -> AsyncStream<T> {
    map(transform).printError()
  }
  
  /// Asynchronously maps the array and streams the result (available when transform is throwing).
  /// - Parameter transform: The transformation to apply to the array's elements.
  /// - Returns: An AsyncThrowingStream of the transformed values and errors.
  @_disfavoredOverload
  func map<T>(_ transform: @escaping (Element) async throws -> T) -> AsyncThrowingStream<T, Error> {
    AsyncThrowingStream { continuation in
      do {
        for element in self {
          continuation.yield(try await transform(element))
        }

        continuation.finish()
      } catch {
        continuation.finish(throwing: error)
      }
    }
  }
}
