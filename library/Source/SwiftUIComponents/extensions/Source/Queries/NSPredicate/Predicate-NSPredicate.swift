// Created by Leopold Lemmermann on 15.12.22.

import Foundation

extension Query.Predicate {
  var nsPredicate: NSPredicate {
    NSPredicate(format: "\(name) \(comparisonSymbol) \(replacementSymbol)", argumentArray: [value])
  }
  
  var comparisonSymbol: String {
    switch comparison {
    case .equal: return "=="
    case .notEqual: return "!="
    case .greater: return ">"
    case .greaterEven: return ">="
    case .lesser: return "<"
    case .lesserEven: return "<="
    }
  }
  
  var replacementSymbol: String {
    switch value {
    case is Bool, is Int:
      return "%d"
    default:
      return "%@"
    }
  }
}
