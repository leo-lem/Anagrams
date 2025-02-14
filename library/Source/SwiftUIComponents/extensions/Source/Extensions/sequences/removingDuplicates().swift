//	Created by Leopold Lemmermann on 10.10.22.

public extension Sequence {
  /// Removes all duplicates from the sequence.
  /// - Returns: An array without duplicates.
  @inlinable func removingDuplicates<T: Equatable>(by accessor: (Element) -> T) -> [Element] {
    var elements = [Element]()
    for element in self where !elements.contains(where: { accessor($0) == accessor(element) }) {
      elements.append(element)
    }
    return elements
  }

  /// Removes all duplicates from the sequence.
  /// - Returns: An array without duplicates.
  /// - Note: Works when the elements are equatable.
  @inlinable func removingDuplicates() -> [Element] where Element: Equatable {
    removingDuplicates { $0 }
  }
}
