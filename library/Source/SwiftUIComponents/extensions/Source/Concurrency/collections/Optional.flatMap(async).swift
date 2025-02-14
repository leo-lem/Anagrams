//	Created by Leopold Lemmermann on 22.11.22.

public extension Optional {
  /// Evaluates the given async closure when this Optional instance is not nil, passing the unwrapped value as a parameter.
  /// - Parameter transform: An async closure that takes the unwrapped value of the instance.
  /// - Returns: The result of the given async closure. If this instance is nil, returns nil.
  @_disfavoredOverload
  func flatMap<T>(_ transform: (Wrapped) async throws -> T?) async rethrows -> T? {
    if let self = self {
      return try await transform(self)
    } else {
      return nil
    }
  }
}
