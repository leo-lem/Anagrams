// Created by Leopold Lemmermann on 12.02.25.

import SwiftUI

/// A tab view with a custom tab bar.
@available(iOS 18.0, *)
public struct TabsView<S: Hashable>: View {
  @Binding var selection: S
  var tabs: [Tab]

  public var body: some View {
    VStack {
      TabView(selection: $selection) {
        ForEach(tabs) { tab in
          SwiftUI.Tab(value: tab.id, content: tab.content, label: tab.item)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .ignoresSafeArea()

      HStack {
        ForEach(tabs) { tab in
          Button { selection = tab.id } label: {
            tab.item()
              .frame(maxWidth: size?.width, maxHeight: size?.height)
              .background {
                if selection == tab.id {
                  Color.accentColor
                    .matchedGeometryEffect(id: "selection", in: namespace)
                    .offset(offset)
                    .gesture(drag)
                }

                GeometryReader { geo in
                  Color.clear
                    .preference(key: ItemSizePreference.self, value: geo.size)
                }
              }
          }
          .zIndex(selection == tab.id ? 0 : 1)
        }
      }
      .background(.regularMaterial)
      .clipShape(.capsule)
      .onPreferenceChange(ItemSizePreference.self) { _size.wrappedValue = $0 }
      .animation(.default, value: .combine(selection, size, offset))
    }
  }

  @State var size: CGSize?
  @State var offset: CGSize = .zero

  @Namespace var namespace

  var currentIndex: Int { tabs.firstIndex { $0.id == selection }! }
  var previous: Tab? { currentIndex > 0 ? tabs[currentIndex - 1] : nil }
  var next: Tab? { (currentIndex < tabs.count - 1) ? tabs[currentIndex + 1] : nil }

  var drag: some Gesture {
    DragGesture()
      .onChanged { value in
        offset.width = value.translation.width
      }
      .onEnded { value in
        offset = .zero
        let index = currentIndex + Int(round(value.translation.width / (size?.width ?? 1)))
        if tabs.indices.contains(index) { selection = tabs[index].id }
      }
  }

  public init(selection: Binding<S>, @Builder content: () -> [Tab]) {
    _selection = selection
    self.tabs = content()
  }

  struct ItemSizePreference: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
      value = CGSize(width: max(value.width, nextValue().width), height: max(value.height, nextValue().height))
    }
  }

  @resultBuilder
  public struct Builder {
    public static func buildBlock(_ components: Tab...) -> [Tab] { components }
    public static func buildEither(first component: Tab) -> Tab { component }
    public static func buildEither(second component: Tab) -> Tab { component }
  }

  public struct Tab: Identifiable {
    public var id: S

    var content: () -> AnyView
    var item: () -> AnyView

    public init<Content: View, Item: View>(
      value: S,
      @ViewBuilder content: @escaping () -> Content,
      @ViewBuilder item: @escaping () -> Item
    ) {
      self.id = value
      self.content = { AnyView(erasing: content()) }
      self.item = { AnyView(erasing: item()) }
    }

    public init<Content: View>(
      _ title: LocalizedStringKey,
      systemImage: String,
      value: S,
      @ViewBuilder content: @escaping () -> Content
    ) {
      self.init(value: value, content: content) {
        Label(title, systemImage: systemImage)
          .labelStyle(.stacked)
          .foregroundColor(.primary)
          .padding()
      }
    }
  }
}

#Preview {
  if #available(iOS 18.0, *) {
    TabsView(selection: .constant(0)) {
      TabsView.Tab("Hello", systemImage: "lightbulb", value: 0) {
        Text("Hello")
      }

      TabsView.Tab("Hello", systemImage: "lightbulb", value: 1) {
        Text("Hello")
      }

      TabsView.Tab("Hello", systemImage: "lightbulb", value: 2) {
        Text("Hello")
      }
    }
  }
}
