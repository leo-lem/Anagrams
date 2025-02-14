//	Created by Leopold Lemmermann on 15.11.22.

@testable import Concurrency
import XCTest

final class LoadingStateTests: XCTestCase {
  func testAddingElementStartsLoading() {
    var state = LoadingState<String>.idle

    let element = "Hello"
    state.add(element)

    XCTAssertEqual(state, .loading([element]), "Loading State is not loading with the correct elements.")
  }

  func testSettingLoadedRetainsElements() {
    var state = LoadingState<String>.idle

    let element = "Hello"
    state.add(element)

    state.finish()

    XCTAssertEqual(state, .loaded([element]), "Loading State is not loaded with the correct elements.")
  }

  func testUpdatingElementsOverridesOldElements() {
    var state = LoadingState<String>.idle

    let element1 = "Hello"
    let element2 = "Goodbye"
    state.add(element1)
    state.update(element2)
    state.finish()

    XCTAssertEqual(state.wrapped, [element2], "Loading State does not contain updated elements.")
  }

  func testFailingKeepsCorrectError() {
    var state = LoadingState<String>.idle

    let error = ExampleError.sumTingWong
    state.finish { _ in throw error }

    if case let .failed(otherError) = state {
      XCTAssertEqual(error.localizedDescription, otherError, "Loading State does not hold specific error.")
    } else {
      XCTFail("Loading State is not failed.")
    }
  }
  
  func testWrapped() {
    var state = LoadingState<String>.idle
    
    state.wrapped = ["First", "Second"]
    state.wrapped?.append("Third")
    
    XCTAssertEqual(state.wrapped, ["First", "Second", "Third"])
  }
}

enum ExampleError: Error, Equatable {
  case sumTingWong,
        sumTingElseWong
}

extension ExampleError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .sumTingWong: return "Oh no, something's wrong!"
    case .sumTingElseWong: return "Oh no, something else is wrong!"
    }
  }
}
