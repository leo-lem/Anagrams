//	Created by Leopold Lemmermann on 22.11.22.

import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
public extension View {
  func awaitSetup<T: ObservableObject>(setup: @escaping () async -> T) -> some View {
    awaitSetup(setup: setup, placeholder: { ProgressView() })
  }
  
  func awaitSetup<T: ObservableObject, Placeholder: View>(
    setup: @escaping () async -> T,
    @ViewBuilder placeholder: @escaping () -> Placeholder
  ) -> some View {
    modifier(AwaitSetup(setup: setup, placeholder: placeholder))
  }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
private struct AwaitSetup<T: ObservableObject, Placeholder: View>: ViewModifier {
  @State private var observable: T?
  
  let setup: () async -> T
  let placeholder: () -> Placeholder
  
  func body(content: Content) -> some View {
    if let observable = observable {
      content
        .environmentObject(observable)
    } else {
      placeholder()
        .task { observable = await setup() }
    }
  }
  init(
    setup: @escaping () async -> T,
    @ViewBuilder placeholder: @escaping () -> Placeholder
  ) {
    self.setup = setup
    self.placeholder = placeholder
  }
}
