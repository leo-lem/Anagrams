//	Created by Leopold Lemmermann on 15.11.22.

public extension LoadingState {
  mutating func add(_ elements: T...) { add(elements) }
  mutating func add(_ elements: [T]) {
    switch self {
    case let .loading(array):
      self = .loading(array + elements)
    default:
      self = .loading(elements)
    }
  }
}
