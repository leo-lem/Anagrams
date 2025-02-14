//	Created by Leopold Lemmermann on 08.11.22.

public extension Query.Predicate where ResultType: KeyPathQueryable {
  init<Value>(
    _ keyPath: PartialKeyPath<ResultType>,
    _ comparison: Comparison = .equal,
    _ value: Value
  ) {
    self.init(keyPath.property, comparison, keyPath.mapValue(value))
  }
  
  init<Value>(
    _ keyPath: PartialKeyPath<ResultType>,
    _ value: Value
  ) {
    self.init(keyPath.property, .equal, keyPath.mapValue(value))
  }
}
