//	Created by Leopold Lemmermann on 10.11.22.

public extension AsyncThrowingStream {
  func mapError(_ transform: @escaping (Error) -> Error) -> AsyncThrowingStream<Element, Error> {
    AsyncThrowingStream<Element, Error> { continuation in
      do {
        for try await element in self {
          continuation.yield(element)
        }
        
        continuation.finish()
      } catch {
        continuation.finish(throwing: transform(error))
      }
    }
  }
}
