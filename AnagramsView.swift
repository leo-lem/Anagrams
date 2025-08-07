// Created by Leopold Lemmermann on 06.08.25.

import Words
import SwiftUI
import SwiftUIExtensions
import SwiftData

public struct AnagramsView: View {
  public var body: some View {
    NavigationStack {
      VStack {
        RootSelecter(root: game.root, language: game.language, start: start)

        GameView(game: game)
          .disabled(outOfTime)
      }
      .toolbar {
        ToolbarItem {
          if game.limit != nil, let countdown {
            Text(max(Duration.seconds(countdown), .zero), format: .units(maximumUnitCount: 1))
              .foregroundColor(outOfTime ? .red : .primary)
              .padding()
          } else {
            Button(.timer, systemImage: "timer") { game.limit = 180 }
              .font(.title2)
              .disabled(outOfTime)
          }
        }

        ToolbarItem(placement: .principal) {
          Text(.score(score))
            .font(.headline)
        }

        ToolbarItem(placement: .confirmationAction) {
          Button(.save, systemImage: "checkmark.seal") {
            game.completedAt = .now
            context.insert(game)
            try? context.save()
          }
          .tint(.green)
        }

        ToolbarItem(placement: .topBarLeading) {
          NavigationLink { LeaderboardView() } label: {
            Label(.leaderboard, systemImage: "trophy")
              .labelStyle(.iconOnly)
          }
        }
      }
    }
    .scrollContentBackground(.hidden)
    .preferredColorScheme(.dark)
  }

  @State var game = Game("universe", language: .english, limit: nil)
  @State var language: Locale.Language = .english
  @State var limit: Duration?

  @Environment(\.modelContext) var context
}

extension AnagramsView {
  var score: Int { game.score }
  var countdown: Double? { game.limit.flatMap { $0 - game.time } }
  var outOfTime: Bool { game.limit.flatMap { $0 < game.time } ?? false }

  func start(_ root: String) {
    game = Game(root, language: game.language, limit: game.limit)
  }
}

#Preview {
  AnagramsView()
    .modelContainer(for: Game.self, inMemory: true)
}
