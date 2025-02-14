//	Created by Leopold Lemmermann on 15.11.22.

public extension Array {
  /// Calls the given async closure on each element in the sequence in the same order as a for-in loop.
  /// - Parameter body: An async  closure that takes an element of the sequence as a parameter.
  @_disfavoredOverload
  func forEach(
    _ body: (Self.Element) async throws -> Void
  ) async rethrows {
    for element in self {
      try await body(element)
    }
    
    self.forEach { _ in}
  }
}
