//  Created by Leopold Lemmermann on 16.01.22.

import ComposableArchitecture
import SwiftUI

@ViewAction(for: Preferences.self)
public struct PreferencesView: View {
  @Bindable public var store: StoreOf<Preferences>

  public var body: some View {
    Form {
      Section(.localizable(.settings)) {
        Picker(.localizable(.language), selection: $store.language) {
          ForEach(Locale.Language.supported, id: \.self) { language in
            Text(
              Locale.current.localizedString(forIdentifier: language.minimalIdentifier) ?? language.minimalIdentifier
            )
            .tag(language)
          }
        }
        .pickerStyle(.segmented)

        Stepper(.localizable(.limit(stepperLabel)), value: $store.limitSeconds, in: 0...900, step: 60)
      }

      Section {
        Button(.localizable(.start), systemImage: "arrowtriangle.right.circle") { send(.startButtonTapped) }
//        Button(.localizable(.continue), systemImage: "arrow.uturn.forward.circle") { send(.resumeButtonTapped) }
      }
    }
  }

  public init(store: StoreOf<Preferences>) { self.store = store }

  var stepperLabel: String {
    if let limit = store.limit {
      limit.formatted(.units(allowed: [.minutes], width: .wide))
    } else {
      String(localizable: .no)
    }
  }
}

#Preview {
  PreferencesView(store: Store(initialState: Preferences.State(), reducer: Preferences.init))
}
