
import Previews
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public extension View {
  func banner<C: View>(
    isPresented: Binding<Bool>,
    defaultStyle: Bool = true,
    dismissAfter: Duration? = nil,
    @ViewBuilder content: @escaping () -> C
  ) -> some View {
    modifier(
      BannerViewModifier(
        isPresented: isPresented,
        defaultStyle: defaultStyle,
        dismissAfter: dismissAfter,
        banner: content
      )
    )
  }

  func banner<T, C: View>(
    presenting: Binding<T?>,
    defaultStyle: Bool = true,
    dismissAfter: Duration? = nil,
    @ViewBuilder content: @escaping (T) -> C
  ) -> some View {
    modifier(
      BannerViewModifier(
        isPresented: Binding(item: presenting),
        defaultStyle: defaultStyle,
        dismissAfter: dismissAfter,
        banner: { presenting.wrappedValue.flatMap(content) }
      )
    )
  }
}

@available(iOS 16, macOS 13, *)
struct BannerViewModifier<Banner: View>: ViewModifier {
  @Binding var isPresented: Bool

  let defaultStyle: Bool,
      dismissAfter: Duration?,
      banner: () -> Banner

  func body(content: Content) -> some View {
    ZStack {
      content

      VStack {
        Group {
          if isPresented {
            VStack(content: banner)
              .if(defaultStyle) { $0
                // sizing
                .padding()
                .frame(width: 350, height: 60)
                // styling
                .background(.regularMaterial)
                .overlay(
                  RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 3)
                    .foregroundColor(.accentColor)
                )
                // outside
                .padding(5)
                .shadow(radius: 3)
              }
              .offset(y: offset)
              .gesture(dragGesture)
              .animation(.interactiveSpring(), value: offset)
          }
        }
        .transition(.offset(y: -100).combined(with: .opacity))
        Spacer()
      }
    }
    .animation(.default, value: isPresented)
    .task {
      if let dismissAfter = dismissAfter {
        try? await Task.sleep(for: dismissAfter)
        isPresented = false
      }
    }
  }

  @State private var offset = 0.0
  private var dragGesture: some Gesture {
    DragGesture()
      .onChanged { gesture in
        let height = gesture.translation.height
        offset = height < 0 ? height : 0.1 * height
      }
      .onEnded { _ in
        if -100 ... 0 ~= offset { isPresented = false }
        offset = .zero
      }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  @available(iOS 16, macOS 13, *)
  struct Banner_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Binding.Preview(false) { binding in
          Button("[ Banner ]") { binding.wrappedValue.toggle() }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .banner(isPresented: binding, dismissAfter: .seconds(3)) {
              Text("I'm a banner!")
            }
        }
      }
    }
  }
#endif
