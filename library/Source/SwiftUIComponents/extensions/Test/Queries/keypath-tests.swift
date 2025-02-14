//  Created by Leopold Lemmermann on 24.11.22.

@testable import Queries
import XCTest

class KeyPathQueriesTests: XCTestCase {
  func testCreatingQuery() {
    var query = Query<Example>(\.id, "Hello")
    if case let .predicate(predicate) = query.predicateType {
      XCTAssertEqual(predicate.value as? String, "Hello", "Query value does not match.")
    } else {
      XCTFail("Query does not have correct type.")
    }

    query = Query([.init(\.id, "Hello"), .init(\.value, 1)], compound: .and)
    if case let .predicates(predicates, compound) = query.predicateType {
      XCTAssertEqual(predicates.count, 2, "Query value does not match.")
      XCTAssertEqual(compound, .and, "Query value does not match.")
    } else {
      XCTFail("Query does not have correct type.")
    }
  }
  
  func testMappingValue() {
    XCTAssertEqual(Example.mapValue(for: \.value, input: 0) as? Int, 1, "The keyPath value was not mapped.")
  }
}

extension Example: KeyPathQueryable {
  static let propertyNames: [PartialKeyPath<Example>: String] = [
    \.id: "id",
    \.value: "value"
  ]
  
  static func mapValue<I>(for keyPath: KeyPath<Example, I>, input: I) -> Any {
    switch keyPath {
    case \.value:
      let input = input as! Int
      return input + 1
    default:
      return input
    }
  }
}
