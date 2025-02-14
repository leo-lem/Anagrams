//	Created by Leopold Lemmermann on 15.11.22.

public extension LoadingState {
  mutating func update(_ elements: T...) { update(elements) }
  mutating func update(_ elements: [T]) {
    switch self {
    case .loaded:
      self = .loaded(elements)
    default:
      self = .loading(elements)
    }
  }
}
