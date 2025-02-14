@testable import Previews
import XCTest

final class PreviewsTests: XCTestCase {
  func testRandomStringHasNumberOfChars() {
    let random = String.random(count: 10)
    
    XCTAssertEqual(random.count, 10, "String has unexpected count.")
  }
  
  func testRandomStringContainsNoUndefinedChars() {
    let random = String.random(count: 10, using: .alphanumerics)
    
    for char in [" ", ".", "/", "\n"] {
      XCTAssertFalse(random.contains(char), "String illegally contains '\(char)'.")
    }
  }
}
