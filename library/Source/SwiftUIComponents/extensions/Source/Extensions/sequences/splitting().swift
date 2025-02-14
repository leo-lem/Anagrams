//	Created by Leopold Lemmermann on 10.11.22.

public extension MutableCollection {
  func splitting(at index: Index) -> (SubSequence, SubSequence) { (self[..<index], self[index...]) }
  
  func splitting(by predicate: (Element) throws -> Bool) rethrows -> ([Element], [Element]) {
    let (first, second): (SubSequence, SubSequence) = try splitting(by: predicate)
    return (Array(first), Array(second))
  }
  
  func splitting(by predicate: (Element) throws -> Bool) rethrows -> (SubSequence, SubSequence) {
    var mutableSelf = self
    return splitting(at: try mutableSelf.partition(by: predicate))
  }
}
