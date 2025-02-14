//	Created by Leopold Lemmermann on 14.11.22.

internal extension Tasks {
  convenience init(keyType: Key.Type) { self.init() }
}

// providing a generic default argument (workaround)
public extension Tasks where Key == String {
  convenience init() { self.init(keyType: Key.self) }
}
