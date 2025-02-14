@testable import Extensions
import XCTest

final class ExtensionsTests: XCTestCase {
  struct Dummy: Identifiable, Hashable {
    var id = UUID()
    var value = Int.random(in: 0..<10)
  }
  
  func testRemovingDuplicates() throws {
    let strings = ["Hello", "there", "Hello", "there"]
    
    XCTAssertTrue(strings.removingDuplicates().count == 2)
    
    let dummy = (Dummy(), Dummy())
    let dummies = [
      dummy.0, dummy.1,
      Dummy(id: dummy.0.id, value: dummy.0.value + 1), Dummy(id: dummy.1.id, value: dummy.1.value - 1)
    ]
    
    XCTAssertTrue(dummies.removingDuplicates(by: \.id).count == 2)
  }
  
  func testIdentifiableSet() throws {
    
    let example = (Dummy(), Dummy())
    
    var mySet: IdentifiableSet = [example.0, example.1, Dummy(id: example.0.id, value: example.0.value + 1)]
    XCTAssertTrue(mySet.count == 2)
    
    XCTAssertFalse(mySet.insert(example.0).inserted, "Element wasn't ignored")
    
    mySet.update(with: Dummy(id: example.0.id, value: 5))
    XCTAssertTrue(mySet[example.0.id]?.value == 5, "Element wasn't updated")
  }
}
