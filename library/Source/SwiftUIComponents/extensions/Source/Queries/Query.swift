//	Created by Leopold Lemmermann on 17.10.22.

public struct Query<ResultType>: Equatable {
  public let predicateType: PredicateType,
             options: Options

  init(
    _ predicateType: PredicateType,
    options: Options = Options()
  ) {
    self.predicateType = predicateType
    self.options = options
  }
}
