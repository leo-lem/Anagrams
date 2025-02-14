//	Created by Leopold Lemmermann on 04.12.22.

import SwiftUI

public extension View {
  @inlinable func create() -> Self { self }
  @inlinable func create<T>(_: T?) -> Self { self }
}
