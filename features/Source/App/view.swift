//  Created by Leopold Lemmermann on 16.01.22.

import ComposableArchitecture
import Database
import Game
import Preferences
import SwiftUIComponents
import Types

public struct AnagramsView: View {
  @Bindable public var store: StoreOf<Anagrams>

  public var body: some View {
    NavigationStack {
      PreferencesView(store: store.scope(state: \.preferences, action: \.preferences))
        .navigationDestination(item: $store.scope(state: \.games?.single, action: \.games.single)) { store in
          SingleplayerView(store: store)
            .background(Color(.background))
        }
        .navigationTitle(Bundle.main[string: "CFBundleDisplayName"])
        .background(Color(.background))
    }
    .scrollContentBackground(.hidden)
    .preferredColorScheme(.dark)
  }

  public init() {
//    do {
//      SwiftDatabase.container = try ModelContainer(for: SingleplayerGame.self)
//    } catch {
//      assertionFailure(error.localizedDescription)
//    }
    
    store = Store(initialState: Anagrams.State()) { Anagrams()._printChanges() }
  }
}

#Preview {
  AnagramsView()
}
