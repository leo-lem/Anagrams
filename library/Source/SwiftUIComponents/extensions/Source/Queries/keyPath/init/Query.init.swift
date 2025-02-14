//	Created by Leopold Lemmermann on 08.11.22.

public extension Query where ResultType: KeyPathQueryable {
  init<Value>(
    _ keyPath: PartialKeyPath<ResultType>,
    _ comparison: Predicate.Comparison,
    _ value: Value,
    options: Options = Options()
  ) {
    self.init(
      keyPath.property, comparison, keyPath.mapValue(value), options: options
    )
  }
  
  init<Value>(
    _ keyPath: PartialKeyPath<ResultType>,
    _ value: Value,
    options: Options = Options()
  ) {
    self.init(
      keyPath.property, .equal, keyPath.mapValue(value), options: options
    )
  }
}
