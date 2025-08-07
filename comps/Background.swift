// Created by Leopold Lemmermann on 07.08.25.

import SwiftUI

struct Background: View {
  var body: some View {
    ZStack {
      Color.background
      LinearGradient(
        colors: [.white.opacity(0.5), .black.opacity(0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .blendMode(.overlay)
      Image(.texture)
        .resizable(resizingMode: .tile)
        .opacity(0.3)
    }
    .ignoresSafeArea()
  }
}
