//  Created by Leopold Lemmermann on 14.01.22.

import SwiftData
import SwiftUI

@main
struct AnagramsApp: App {
  var body: some Scene {
    WindowGroup {
//      AnagramsView()
      LeaderboardView()
    }
    .modelContainer(for: Game.self)
  }
}
