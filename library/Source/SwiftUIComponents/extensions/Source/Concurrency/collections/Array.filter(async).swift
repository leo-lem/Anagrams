//	Created by Leopold Lemmermann on 04.12.22.

public extension Array {
  /// Asynchronously maps the array, while dropping nil results, and returns the result.
  /// - Parameter transform: The transformation to apply to the array's elements.
  /// - Returns: An array of the transformed values.
  @_disfavoredOverload
  func filter(_ isIncluded: @escaping (Element) async throws -> Bool) async throws -> [Element] {
    try await filter(isIncluded).collect()
  }
  
  /// Asynchronously maps the array, while dropping nil results, and streams the result (available when transform is non-throwing).
  /// - Parameter transform: The transformation to apply to the array's elements.
  /// - Returns: An AsyncStream of the transformed values.
  @_disfavoredOverload
  func filter(_ isIncluded: @escaping (Element) async -> Bool) -> AsyncStream<Element> {
    filter(isIncluded).printError()
  }

  /// Asynchronously maps the array, while dropping nil results, and streams the result (available when transform is throwing).
  /// - Parameter transform: The transformation to apply to the array's elements.
  /// - Returns: An AsyncThrowingStream of the transformed values and errors.
  @_disfavoredOverload
  func filter(_ isIncluded: @escaping (Element) async throws -> Bool) -> AsyncThrowingStream<Element, Error> {
    AsyncThrowingStream { continuation in
      do {
        for element in self {
          if try await isIncluded(element) { continuation.yield(element) }
        }
        
        continuation.finish()
      } catch {
        continuation.finish(throwing: error)
      }
    }
  }
}
