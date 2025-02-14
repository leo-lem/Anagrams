//	Created by Leopold Lemmermann on 29.11.22.

import SwiftUI

@available(iOS 16, macOS 13, *)
public extension View {
  func glare(
    color: Color = .white,
    duration: Duration = .seconds(1),
    delay: Duration = .seconds(0)
  ) -> some View {
    modifier(Glare(color: color, duration: duration, delay: delay))
  }
}

@available(iOS 16, macOS 13, *)
struct Glare: ViewModifier {
  let color: Color,
      duration: Duration,
      delay: Duration

  @State private var offset = 0.0

  func body(content: Content) -> some View {
    content
      .overlay(alignment: .center) {
        GeometryReader { geo in
          let (width, height) = (geo.size.width, geo.size.height)

          color
            // styling
              .opacity(0.5)
              .blur(radius: 5)
              // positioning
              .frame(width: width / 6, height: 2 * height)
              .rotationEffect(.degrees(10))
              .offset(x: offset, y: -20)
              // animate
              .task {
                try? await Task.sleep(for: delay)

                while true {
                  start(width)
                  try? await Task.sleep(for: duration)
                  reset(width)
                }
              }
        }
        .clipped()
      }
  }

  private func start(_ width: Double) {
    withAnimation(.easeInOut(duration: Double(duration.components.seconds))) {
      offset = 1.1 * width
    }
  }

  private func reset(_ width: Double) {
    offset = -0.2 * width
  }
}

// MARK: - (PREVIEWS)

@available(iOS 16, macOS 13, *)
struct GlareView_Previews: PreviewProvider {
  static var previews: some View {
    Text("Hello there")
      .padding()
      .background(.gray)
      .glare(color: .black)
  }
}
