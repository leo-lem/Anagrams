//	Created by Leopold Lemmermann on 02.12.22.

import Combine

public extension Publisher where Failure == Never {
  var stream: AsyncStream<Output> {
    AsyncStream { continuation in
      let cancellable = self.sink { completion in
        continuation.finish()
      } receiveValue: { output in
        continuation.yield(output)
      }
      
      continuation.onTermination = { _ in cancellable.cancel() }
    }
  }
}

public extension Publisher where Failure == Error {
  var stream: AsyncThrowingStream<Output, Error> {
    AsyncThrowingStream { continuation in
      let cancellable = self.sink { completion in
        switch completion {
        case .finished: continuation.finish()
        case let .failure(error): continuation.finish(throwing: error)
        }
      } receiveValue: { output in
        continuation.yield(output)
      }
      
      continuation.onTermination = { _ in cancellable.cancel() }
    }
  }
}
