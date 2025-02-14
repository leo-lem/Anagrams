//	Created by Leopold Lemmermann on 05.12.22.

public extension Sequence where Element: Identifiable {
  func element(with id: Element.ID) -> Element? { first(where: { $0.id == id }) }
}

public extension Collection where Element: Identifiable {
  func index(ofElementWith id: Element.ID) -> Index? { firstIndex(where: { $0.id == id }) }
}
