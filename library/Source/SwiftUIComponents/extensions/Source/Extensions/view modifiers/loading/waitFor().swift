//	Created by Leopold Lemmermann on 04.12.22.

import SwiftUI

public extension View {
  @available(iOS 14, macOS 11, *)
  @inlinable
  func waitFor<T>(_ optional: T?) -> some View {
    waitFor(optional, content: self.create)
  }
  
  @available(iOS 14, macOS 11, *)
  @inlinable
  func waitFor<T, Content: View>(
    _ optional: T?,
    @ViewBuilder content: (T) -> Content
  ) -> some View {
    waitFor(optional, content: content, placeholder: ProgressView.init)
  }
  
  @inlinable
  func waitFor<T, Placeholder: View>(
    _ optional: T?,
    placeholder: () -> Placeholder
  ) -> some View {
    waitFor(optional, content: self.create, placeholder: placeholder)
  }
  
  @inlinable
  @ViewBuilder
  func waitFor<T, Content: View, Placeholder: View>(
    _ optional: T?,
    @ViewBuilder content: (T) -> Content,
    @ViewBuilder placeholder: () -> Placeholder
  ) -> some View {
    if let something = optional { content(something) } else { placeholder() }
  }
}
