//	Created by Leopold Lemmermann on 14.11.22.

import Combine
import Concurrency
import XCTest

@available(iOS 16, macOS 13, *)
final class AsyncStreamsTests: XCTestCase {
  func testAsyncInit() async {
    let stream = AsyncStream { continuation in
      for i in 0 ..< 10 {
        continuation.yield(i)
        await sleep(for: .seconds(0.1))
      }

      continuation.finish()
    }

    for await element in stream {
      XCTAssertNotNil(element, "No element was produced")
    }
  }

  func testCollect() async throws {
    let stream = AsyncThrowingStream { continuation in
      for i in 0 ..< 10 {
        continuation.yield(i)
        await sleep(for: .seconds(0.1))
      }

      continuation.finish()
    }

    let otherStream = AsyncStream { continuation in
      for i in 0 ..< 10 {
        continuation.yield(i)
        await sleep(for: .seconds(0.1))
      }

      continuation.finish()
    }

    try await stream.collect()
    await otherStream.collect()
  }

  func testMapErrorFinishes() async throws {
    let stream = AsyncThrowingStream { continuation in
      for i in 0 ..< 10 {
        continuation.yield(i)
        await sleep(for: .seconds(0.1))
      }

      continuation.finish()
    }
    .mapError { $0 }

    for try await _ in stream {}
  }

  func testMappingStream() async throws {
    let stream = AsyncThrowingStream { continuation in
      for i in 0 ..< 10 {
        continuation.yield(i)
        await sleep(for: .seconds(0.1))
      }

      continuation.finish()
    }

    let otherStream = AsyncStream { continuation in
      for i in 0 ..< 10 {
        continuation.yield(i)
        await sleep(for: .seconds(0.1))
      }

      continuation.finish()
    }

    _ = stream.map(String.init)
    _ = otherStream.map(String.init)
  }

  enum Event {
    case something(UUID, type: Any), somethingElse(UUID, type: Any)
  }

  func testPublisherStreamWithSingleValue() async {
    continueAfterFailure = true

    for _ in 0 ..< 100 {
      let pub = PassthroughSubject<Event, Never>()
      let valuesAreStreamed = XCTestExpectation(description: "Values are streamed")
      let streamFinishes = XCTestExpectation(description: "Stream finishes.")

      Task {
        try? await Task.sleep(for: .zero)
        pub.send(.something(UUID(), type: Int.self))
        pub.send(completion: .finished)
      }

      for await _ in pub.stream { valuesAreStreamed.fulfill() }
      streamFinishes.fulfill()

      await fulfillment(of: [valuesAreStreamed, streamFinishes], timeout: 0.5)
    }

    continueAfterFailure = false
  }

  func testPublisherStream() async {
    let pub = PassthroughSubject<Event, Never>()
    let valuesAreStreamed = XCTestExpectation(description: "Values are streamed")
    let streamFinishes = XCTestExpectation(description: "Stream finishes.")

    Task {
      valuesAreStreamed.expectedFulfillmentCount = 100_000

      for i in 0 ..< valuesAreStreamed.expectedFulfillmentCount {
        let event: Event = (i % 2 == 0) ?
          .something(UUID(), type: Int.self) :
          .somethingElse(UUID(), type: Double.self)

        pub.send(event)
      }
      pub.send(completion: .finished)
    }

    for await _ in pub.stream { valuesAreStreamed.fulfill() }
    streamFinishes.fulfill()

    await fulfillment(of: [valuesAreStreamed, streamFinishes], timeout: 0.5)
  }
}
