//	Created by Leopold Lemmermann on 29.11.22.

#if os(iOS)
import Previews
import SwiftUI

@available(iOS 15, *)
public extension View {
  func compactDismissButton() -> some View {
    overlay(alignment: .topTrailing) {
      CompactDismissButton()
        .labelStyle(.iconOnly)
        .padding()
    }
  }
  
  func compactDismissButtonToolbar() -> some View {
    toolbar {
      ToolbarItem(placement: .navigationBarTrailing, content: CompactDismissButton.init)
    }
  }
}

@available(iOS 15, *)
public struct CompactDismissButton: View {
  @Environment(\.verticalSizeClass) private var vSize
  @Environment(\.dismiss) private var dismiss

  public var body: some View {
    if vSize == .compact {
      Button(action: dismiss.callAsFunction) { Label("Dismiss", systemImage: "chveron.down") }
    }
  }
}

// MARK: - (PREVIEWS)

@available(iOS 16, *)
struct ToolbarDismissButtonForCompactLayout_Previews: PreviewProvider {
  static var previews: some View {
    Text("")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .compactDismissButton()
      .previewInSheet()
      .previewDisplayName("Bare")

    NavigationStack {
      Text("")
        .compactDismissButtonToolbar()
    }
    .previewInSheet()
    .previewDisplayName("Toolbar")
  }
}
#endif
