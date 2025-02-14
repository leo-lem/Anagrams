//	Created by Leopold Lemmermann on 22.11.22.

import SwiftUI

public extension View {
  func previewInSheet() -> some View {
    Binding.Preview(false) { binding in
      Button("[Sheet]") { binding.wrappedValue.toggle() }
        .sheet(isPresented: binding) { self }
        .onAppear { binding.wrappedValue = true }
    }
    .previewDisplayName("Sheet")
  }
}
