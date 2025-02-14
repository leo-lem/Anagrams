//	Created by Leopold Lemmermann on 24.11.22.

@testable import Queries
import XCTest

class QueriesTests: XCTestCase {
  func testCreatingQuery() {
    var query = Query<Example>(true)
    if case let .bool(bool) = query.predicateType {
      XCTAssertEqual(bool, true, "Query value does not match.")
    } else {
      XCTFail("Query does not have correct type.")
    }
    
    query = Query("id", "Hello")
    if case let .predicate(predicate) = query.predicateType {
      XCTAssertEqual(predicate.value as? String, "Hello", "Query value does not match.")
    } else {
      XCTFail("Query does not have correct type.")
    }
    
    query = Query([.init("id", "Hello"), .init("value", 1)], compound: .and)
    if case let .predicates(predicates, compound) = query.predicateType {
      XCTAssertEqual(predicates.count, 2, "Query value does not match.")
      XCTAssertEqual(compound, .and, "Query value does not match.")
    } else {
      XCTFail("Query does not have correct type.")
    }
  }
  
  func testQueryOptions() {
    let max = 10, batch = 2
    let query = Query<Example>(true, options: .init(maxItems: max, batchSize: batch))
    
    XCTAssertEqual(query.options.maxItems, max, "The max items count does not match")
    XCTAssertEqual(query.options.batchSize, batch, "The batch size does not match")
  }
  
  func testQueryEvaluation() {
    let example = Example()
    let (id, value) = (example.id, example.value)
    
    for query: Query<Example> in [
      Query(true),
      Query(\.id, id),
      Query([.init(\.id, id), .init(\.value, value - 1)], compound: .and) // keypath map adds 1
    ] {
      XCTAssertTrue(query.evaluate(example), "Unexpected evaluation result.")
    }
    
    for query: Query<Example> in [
      Query(false),
      Query(\.id, UUID()),
      Query([.init(\.id, UUID()), .init(\.value, value + 1)], compound: .or)
    ] {
      XCTAssertFalse(query.evaluate(example), "Unexpected evaluation result.")
    }
  }
}
