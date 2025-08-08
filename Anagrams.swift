//  Created by Leopold Lemmermann on 14.01.22.

import Model
import SwiftUI

@main
struct AnagramsApp: App {
  var body: some Scene {
    WindowGroup {
      AnagramsView()
    }
    .modelContainer(for: LocalGame.self, isUndoEnabled: false)
  }
}

extension AnagramsApp {
  static let enableTimer = false
}
