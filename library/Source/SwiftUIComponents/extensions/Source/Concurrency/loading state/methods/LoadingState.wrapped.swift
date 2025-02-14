//	Created by Leopold Lemmermann on 22.11.22.

public extension LoadingState {
  var wrapped: [T]? {
    get {
      switch self {
      case .loading(let array), .loaded(let array):
        return array
      default:
        return nil
      }
    }
    set {
      if let newValue { update(newValue) } else { self = .idle }
    }
  }
}
