//  Created by Leopold Lemmermann on 14.01.22.

public struct TitleScreen: View {
  public var body: some View {
    VStack {
      Logo()

      if let load, load { ProgressView() }
    }
    .task {
      if load != nil {
        try? await Task.sleep(for: .seconds(1))
        load = true
      }
    }
    .animation(.default, value: load)
  }

  @State var load: Bool?

  public init(load: Bool = false) {
    _load = .init(initialValue: load ? false : nil)
  }
}

#Preview {
  TitleScreen()
}

#Preview("Loading") {
  TitleScreen(load: true)
}
