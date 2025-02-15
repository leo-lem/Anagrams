//  Created by Leopold Lemmermann on 16.01.22.

public struct Logo: View {
  public var body: some View {
    Text("Leos Anagrams")
      .font(.largeTitle)
      .foregroundStyle(Color.accentColor)
  }

  public init() {}
}

#Preview {
  Logo()
}
