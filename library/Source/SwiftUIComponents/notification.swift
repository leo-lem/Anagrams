//  Created by Leopold Lemmermann on 04.01.22.

import Extensions

public extension View {
  func notification<T: Transition>(
    _ title: LocalizedStringKey,
    item: Binding<String?>,
    transition: T = .opacity.combined(with: .move(edge: .top))
  ) -> some View {
    self.overlay(alignment: .top) {
      Group {
        if let wrapped = item.wrappedValue {
          VStack {
            Text(title).font(.headline)
            Text(wrapped).font(.footnote)
          }
          .padding()
          .frame(maxWidth: .infinity)
          .background(Material.thin.shadow(.inner(radius: 1)), in: .rect(cornerRadius: 10))
          .padding(.horizontal)
          .onTapGesture { item.wrappedValue = nil }
          .transition(transition)
        }
      }
      .animation(.default, value: item.wrappedValue)
    }
  }
}

#Preview {
  @Previewable @State var item: String?

  Button(String("Alert")) { item = item == nil ? "This is an alert!" : nil }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .notification("Hello", item: $item)
}
