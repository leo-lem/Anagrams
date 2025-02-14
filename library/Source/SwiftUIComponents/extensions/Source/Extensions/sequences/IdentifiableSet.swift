// Created by Leopold Lemmermann on 16.12.22.

public struct IdentifiableSet<Element: Hashable & Identifiable>: Hashable {
  private var contents = Set<Element>()
  
  public init(_ set: Set<Element>) { contents = Set(set.removingDuplicates(by: \.id)) }
}

public extension IdentifiableSet {
  subscript(_ id: Element.ID) -> Element? {
    get { element(with: id) }
    set {
      if let newValue { update(with: newValue) } else { _ = element(with: id).flatMap { remove($0) } }
    }
  }
  
  func contains(with id: Element.ID) -> Bool { element(with: id) != nil }

  mutating func removeAll(where predicate: (Element) throws -> Bool) rethrows {
    try first(where: predicate).flatMap { self[$0.id] = nil }
  }
}

extension IdentifiableSet: Codable where Element: Codable {}
extension IdentifiableSet: Sendable where Element: Sendable {}

extension IdentifiableSet: CustomStringConvertible, CustomDebugStringConvertible, CustomReflectable {
  public var description: String { contents.description }
  public var debugDescription: String { contents.debugDescription }
  public var customMirror: Mirror { contents.customMirror }
}

extension IdentifiableSet: Collection, ExpressibleByArrayLiteral {
  public typealias Index = Set<Element>.Index
  public typealias Element = Set<Element>.Element

  public var startIndex: Index { contents.startIndex }
  public var endIndex: Index { contents.endIndex }
  public subscript(index: Index) -> Iterator.Element { contents[index] }
  public func index(after i: Index) -> Index { contents.index(after: i) }
  
  public init(arrayLiteral elements: Element...) { self.init(Set(elements)) }
}

extension IdentifiableSet: SetAlgebra {
  public var isEmpty: Bool { contents.isEmpty }

  public init() { self.init(Set()) }

  public func contains(_ member: Element) -> Bool { contents.contains(member) }

  @discardableResult
  public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
    if let member = contents.element(with: newMember.id) {
      return (false, member)
    } else {
      return contents.insert(newMember)
    }
  }
  @discardableResult public mutating func update(with newMember: Element) -> Element? {
    if let member = contents.element(with: newMember.id) { contents.remove(member) }
    return contents.update(with: newMember)
  }
  @discardableResult public mutating func remove(_ member: Element) -> Element? { contents.remove(member) }

  public func union(_ other: Self) -> Self {
    Self(contents.union(other).removingDuplicates(by: \.id))
  }
  public func intersection(_ other: Self) -> Self {
    Self(contents.intersection(other).removingDuplicates(by: \.id))
  }
  public func symmetricDifference(_ other: Self) -> Self {
    Self(contents.symmetricDifference(other).removingDuplicates(by: \.id))
  }
}

extension SetAlgebra {
  public mutating func formUnion(_ other: Self) { self = union(other) }
  public mutating func formIntersection(_ other: Self) { self = intersection(other) }
  public mutating func formSymmetricDifference(_ other: Self) { self = symmetricDifference(other) }
}
