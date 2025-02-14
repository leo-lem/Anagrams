//	Created by Leopold Lemmermann on 10.11.22.

public extension AsyncStream {
  func map<T>(_ transform: @escaping (Self.Element) -> T) -> AsyncStream<T> {
    AsyncStream<T> { continuation in
      for await element in self {
        continuation.yield(transform(element))
      }
      continuation.finish()
    }
  }

  func map<T>(_ transform: @escaping (Self.Element) async -> T) -> AsyncStream<T> {
    AsyncStream<T> { continuation in
      for await element in self {
        continuation.yield(await transform(element))
      }
      continuation.finish()
    }
  }
}

public extension AsyncThrowingStream {
  func map<T>(_ transform: @escaping (Self.Element) throws -> T) -> AsyncThrowingStream<T, Error> {
    AsyncThrowingStream<T, Error> { continuation in
      do {
        for try await element in self {
          continuation.yield(try transform(element))
        }
        continuation.finish()
      } catch {
        continuation.finish(throwing: error)
      }
    }
  }

  func map<T>(_ transform: @escaping (Self.Element) async throws -> T) -> AsyncThrowingStream<T, Error> {
    AsyncThrowingStream<T, Error> { continuation in
      do {
        for try await element in self {
          continuation.yield(try await transform(element))
        }
        continuation.finish()
      } catch {
        continuation.finish(throwing: error)
      }
    }
  }
}
