// Created by Leopold Lemmermann on 15.12.22.

public extension Query {
  func evaluate(_ object: ResultType) -> Bool {
    switch predicateType {
    case let .bool(bool):
      return bool
    case let .predicate(predicate):
      return evaluate(object, with: predicate)
    case let .predicates(predicates, compound):
      switch compound {
      case .and: return predicates.allSatisfy { evaluate(object, with: $0) }
      case .or: return predicates.contains { evaluate(object, with: $0) }
      }
    }
  }
}

private extension Query {
  func evaluate(_ object: ResultType, with predicate: Predicate) -> Bool {
    compare(predicate.comparison, lhs: predicate.value, rhs: getValue(for: predicate.name, of: object) as Any)
  }
  
  func getValue(for name: String, of object: ResultType) -> Any? {
    for child in Mirror(reflecting: object).children where child.label == name { return child.value }
    return nil
  }
  
  func compare<T>(_ comparison: Predicate.Comparison, lhs: T, rhs: T) -> Bool {
    switch comparison {
    case .equal: return areEqual(lhs: lhs, rhs: rhs)
    case .notEqual: return !areEqual(lhs: lhs, rhs: rhs)
    case .greater: return isGreater(lhs: lhs, rhs: rhs)
    case .lesser: return isLesser(lhs: lhs, rhs: rhs)
    case .greaterEven: return !isLesser(lhs: lhs, rhs: rhs)
    case .lesserEven: return !isGreater(lhs: lhs, rhs: rhs)
    }
  }
}
