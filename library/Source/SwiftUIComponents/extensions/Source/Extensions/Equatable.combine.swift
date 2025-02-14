// Created by Leopold Lemmermann on 29.04.23.

public extension Equatable where Self == AnyHashable {
  /// Convenient, when you want to observe changes in multiple objects (for example, in SwiftUIs `animation(,value:)`).
  static func combine(_ elements: AnyHashable...) -> Self { Self(elements) }
}
