// Created by Leopold Lemmermann on 12.02.25.

import SwiftUI

public extension LabelStyle where Self == StackedLabelStyle {
  static var stacked: Self { StackedLabelStyle() }
}

public struct StackedLabelStyle: LabelStyle {
  public func makeBody(configuration: Configuration) -> some View {
    VStack {
      configuration.icon
        .imageScale(.large)

      configuration.title
        .font(.caption)
    }
  }
}
