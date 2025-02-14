//	Created by Leopold Lemmermann on 04.12.22.

extension AsyncThrowingStream {
  func printError() -> AsyncStream<Element> {
    AsyncStream { continuation in
      do {
        for try await element in self { continuation.yield(element) }
        
        continuation.finish()
      } catch { print(error) }
    }
  }
}
