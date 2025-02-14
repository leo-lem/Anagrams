//	Created by Leopold Lemmermann on 28.11.22.

import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public extension View {
  func embedInNavigationStack() -> some View {
    NavigationStack(root: self.create)
  }
}
