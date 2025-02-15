//  Created by Leopold Lemmermann on 04.01.22.

import Extensions
import SwiftUI

public extension View {
  func notification<T: Transition>(
    _ title: LocalizedStringKey,
    message: LocalizedStringKey,
    isPresented: Binding<Bool>,
    transition: T = .opacity.combined(with: .move(edge: .top))
  ) -> some View {
    self.overlay(alignment: .top) {
      Group {
        if isPresented.wrappedValue {
          VStack {
            Text(title).font(.headline)
            Text(message).font(.footnote)
          }
          .padding()
          .frame(maxWidth: .infinity)
          .background(Material.thin.shadow(.inner(radius: 1)), in: .rect(cornerRadius: 10))
          .padding(.horizontal)
          .onTapGesture { isPresented.wrappedValue = false }
          .transition(transition)
        }
      }
      .animation(.default, value: isPresented.wrappedValue)
    }
  }
}

#Preview {
  @Previewable @State var isPresented = false

  Button("Alert") { isPresented.toggle() }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .notification(
      "Hello",
      message: "This is an alert!",
      isPresented: $isPresented
    )
}
