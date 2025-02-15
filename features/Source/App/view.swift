//  Created by Leopold Lemmermann on 16.01.22.

import ComposableArchitecture
import Game
import Preferences
import SwiftUIComponents

public struct AnagramsView: View {
  @Bindable public var store: StoreOf<Anagrams>

  public var body: some View {
    NavigationStack {
      VStack {
        PreferencesView(store: store.scope(state: \.preferences, action: \.preferences))
          .navigationDestination(item: $store.scope(state: \.games?.single, action: \.games.single)) { store in
            SingleplayerView(store: store)
          }
          .navigationTitle(Bundle.main[string: "CFBundleDisplayName"])
      }
    }
  }

  public init() {
    store = Store(initialState: Anagrams.State()) { Anagrams()._printChanges() }
  }
}

#Preview {
  AnagramsView()
}
