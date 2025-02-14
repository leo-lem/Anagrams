//	Created by Leopold Lemmermann on 21.10.22.

import Foundation

public protocol KeyPathQueryable {
  static var propertyNames: [PartialKeyPath<Self>: String] { get }
  static func mapValue<I>(for keyPath: KeyPath<Self, I>, input: I) -> Any
}

public extension KeyPathQueryable {
  static func mapValue<I>(for keyPath: KeyPath<Self, I>, input: I) -> Any { input }
}

public extension PartialKeyPath where Root: KeyPathQueryable {
  var property: String {
    if let name = Root.propertyNames[self] {
      return name
    } else {
      fatalError("Missing key path in property names dictionary for \(type(of: self)).")
    }
  }

  func mapValue<I>(_ input: I) -> Any {
    if let keyPath = self as? KeyPath<Root, I> {
      return Root.mapValue(for: keyPath, input: input)
    } else {
      return input
    }
  }
}
