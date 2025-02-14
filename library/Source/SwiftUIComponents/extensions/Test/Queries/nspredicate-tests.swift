//  Created by Leopold Lemmermann on 24.11.22.

@testable import Queries
import XCTest

class NSPredicateTests: XCTestCase {
  func testEvaluation() {
    let example = ExampleObject()
    
    for query in [
      Query<ExampleObject>(true),
      .init("id", example.id),
      .init("value", .lesser, example.value + 1),
      .init([.init("id", example.id), .init("value", example.value)], compound: .and)
    ] {
      let pred = query.getNSPredicate()
      XCTAssertTrue(pred.evaluate(with: example), "Predicate does not match example.")
    }
  }
}

@objc
class ExampleObject: NSObject {
  @objc let id: UUID
  @objc var value: Int

  @objc init(id: UUID = UUID(), value: Int = .random(in: 0 ..< 100)) {
    self.id = id
    self.value = value
  }
}
