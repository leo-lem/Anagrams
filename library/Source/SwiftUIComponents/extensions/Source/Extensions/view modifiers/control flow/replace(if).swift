//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

public extension View {
  func replaceWhenEmpty<C: Collection>(_ collection: C) -> some View {
    replace(if: collection.isEmpty) { Text("No data").font(.largeTitle) }
  }

  func replaceWhileLoading(when isLoading: Bool) -> some View {
    replace(if: isLoading) {
      ProgressView()
        .accessibilityValue("Loading")
    }
  }

  func replace<Content: View>(
    if condition: @autoclosure () -> Bool,
    placeholder: () -> Content
  ) -> some View {
    Group {
      if condition() {
        placeholder()
      } else {
        self
      }
    }
  }

  @_disfavoredOverload
  func replace<S: StringProtocol>(
    if condition: @autoclosure () -> Bool,
    placeholder: S
  ) -> some View {
    Group {
      if condition() {
        Text(placeholder)
      } else {
        self
      }
    }
  }

  func replace(
    if condition: @autoclosure () -> Bool,
    placeholder: LocalizedStringKey
  ) -> some View {
    Group {
      if condition() {
        Text(placeholder)
      } else {
        self
      }
    }
  }
}
