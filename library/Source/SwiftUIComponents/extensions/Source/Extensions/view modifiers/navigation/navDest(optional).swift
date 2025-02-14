//	Created by Leopold Lemmermann on 27.10.22.

import SwiftUI

public extension View {
  @available(iOS 16, macOS 13, *)
  func navigationDestination<T, V: View>(item: Binding<T?>, @ViewBuilder destination: (T) -> V) -> some View {
    navigationDestination(isPresented: Binding(item: item)) {
      if let value = item.wrappedValue { destination(value) }
    }
  }
}
