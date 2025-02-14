//	Created by Leopold Lemmermann on 10.11.22.

public extension AsyncStream {
  /// Constructs an asynchronous stream for an element type, using the specified buffering policy and element-producing asynchronous closure.
  /// - Parameters:
  ///   - elementType: The type of element the AsyncStream produces.
  ///   - bufferingPolicy: A Continuation.BufferingPolicy value to set the stream’s buffering behavior. By default, the stream buffers an unlimited number of elements. You can also set the policy to buffer a specified number of oldest or newest elements.
  ///   - build: A custom closure that yields values to the AsyncStream. This closure receives an AsyncStream.Continuation instance that it uses to provide elements to the stream and terminate the stream when finished.
  init(
    _ elementType: Element.Type = Element.self,
    bufferingPolicy: Continuation.BufferingPolicy = .unbounded,
    build: @escaping (Continuation) async -> Void
  ) {
    self.init(elementType, bufferingPolicy: bufferingPolicy) { continuation in
      let task = Task { await build(continuation) }
      continuation.onTermination = { @Sendable _ in task.cancel() }
    }
  }
}

public extension AsyncThrowingStream {
  /// Constructs an asynchronous stream for an element type, using the specified buffering policy and element-producing asynchronous closure.
  /// - Parameters:
  ///   - elementType: The type of element the AsyncThrowingStream produces.
  ///   - bufferingPolicy: A Continuation.BufferingPolicy value to set the stream’s buffering behavior. By default, the stream buffers an unlimited number of elements. You can also set the policy to buffer a specified number of oldest or newest elements.
  ///   - build: A custom closure that yields values to the AsyncThrowingStream. This closure receives an AsyncThrowingStream.Continuation instance that it uses to provide elements to the stream and terminate the stream when finished.
  init(
    _ elementType: Element.Type = Element.self,
    bufferingPolicy: Continuation.BufferingPolicy = .unbounded,
    build: @escaping (Continuation) async -> Void
  ) where Failure == any Error {
    self.init(elementType, bufferingPolicy: bufferingPolicy) { continuation in
      let task = Task { await build(continuation) }
      continuation.onTermination = { @Sendable _ in task.cancel() }
    }
  }
}

