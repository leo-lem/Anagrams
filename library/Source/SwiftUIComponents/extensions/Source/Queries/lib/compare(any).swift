// Created by Leopold Lemmermann on 15.12.22.

func isLesser(lhs: Any, rhs: Any) -> Bool {
  guard let lhs = lhs as? any Comparable, let rhs = rhs as? any Comparable else { return false }
  return lhs.isLesser(rhs)
}

func isGreater(lhs: Any, rhs: Any) -> Bool {
  guard let lhs = lhs as? any Comparable, let rhs = rhs as? any Comparable else { return false }
  return lhs.isGreater(rhs)
}

extension Comparable {
  func isGreater(_ other: any Comparable) -> Bool {
    guard let other = other as? Self else { return other.isExactlyGreater(self) }
    return self > other
  }
  
  private func isExactlyGreater(_ other: any Comparable) -> Bool {
    guard let other = other as? Self else { return false }
    return self > other
  }
  
  func isLesser(_ other: any Comparable) -> Bool {
    guard let other = other as? Self else { return other.isExactlyLesser(self) }
    return self < other
  }
  
  private func isExactlyLesser(_ other: any Comparable) -> Bool {
    guard let other = other as? Self else { return false }
    return self < other
  }
}
