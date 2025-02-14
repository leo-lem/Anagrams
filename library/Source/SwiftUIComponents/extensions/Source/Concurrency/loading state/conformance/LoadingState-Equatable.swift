//	Created by Leopold Lemmermann on 15.11.22.

extension LoadingState: Equatable where T: Equatable {
  public static func == (lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      return true
    case let (.loading(lhsItems), .loading(rhsItems)):
      return rhsItems == lhsItems
    case let (.loaded(lhsItems), .loaded(rhsItems)):
      return rhsItems == lhsItems
    case let (.failed(lhsError), .failed(rhsError)):
      if let lhsError = lhsError, let rhsError = rhsError {
        return lhsError as AnyObject === rhsError as AnyObject
      } else { fallthrough }
    default:
      return false
    }
  }
}
