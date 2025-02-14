//	Created by Leopold Lemmermann on 17.10.22.

import CoreData

public extension Query {
  func getNSPredicate() -> NSPredicate {
    switch predicateType {
    case let .bool(bool):
      return bool.nsPredicate

    case let .predicate(predicate):
      return predicate.nsPredicate

    case let .predicates(predicates, compound):
      switch compound {
      case .and:
        return NSCompoundPredicate(type: .and, subpredicates: predicates.map(\.nsPredicate))
      case .or:
        return NSCompoundPredicate(type: .or, subpredicates: predicates.map(\.nsPredicate))
      }
    }
  }
}
