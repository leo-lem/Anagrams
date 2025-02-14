// Created by Leopold Lemmermann on 15.12.22.

func areEqual(lhs: Any, rhs: Any) -> Bool {
  guard let lhs = lhs as? any Equatable, let rhs = rhs as? any Equatable else { return false }
  return lhs.isEqual(rhs)
}

extension Equatable {
  func isEqual(_ other: any Equatable) -> Bool {
    guard let other = other as? Self else { return other.isExactlyEqual(self) }
    return self == other
  }
    
  private func isExactlyEqual(_ other: any Equatable) -> Bool {
    guard let other = other as? Self else { return false }
    return self == other
  }
}

