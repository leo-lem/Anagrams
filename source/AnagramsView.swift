// Created by Leopold Lemmermann on 06.08.25.

import Words
import SwiftUI
import SwiftUIExtensions
import SwiftData

public struct AnagramsView: View {
  public var body: some View {
    NavigationStack {
      VStack {
        RootSelecter(root: game.root, language: language, start: start)

        GameView(game: game)
          .disabled(outOfTime)
      }
      .background(Background())
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          if game.limit != nil, let countdown {
            Text(
              max(Duration.seconds(countdown), .zero), format: .units(width: .narrow, maximumUnitCount: 1)
            )
            .foregroundStyle(outOfTime ? .red : .primary)
          }
        }

        ToolbarItem(placement: .confirmationAction) {
          Menu(.save, systemImage: "checkmark.seal") {
            Button(.save, systemImage: "checkmark.seal") {
              game.completedAt = .now
              context.insert(game)
              try? context.save()
            }

            NavigationLink {
              LeaderboardView()
                .background { Background() }
            } label: {
              Label(.leaderboard, systemImage: "trophy")
            }
          }
        }

        ToolbarItem(placement: .primaryAction) {
          Menu(.settings, systemImage: "gear") {
            Button(.timer, systemImage: "timer") {
              game.limit = game.limit == nil ? 180 : nil
            }
            .font(.title2)
            .onChange(of: limit) {
              if $1 == nil { start() }
            }

            Picker(.language, selection: $language) {
              ForEach(Language.allCases, id: \.self) { language in
                Text(
                  Locale.current.localizedString(forIdentifier: language.locale.minimalIdentifier)!
                )
                .tag(language)
              }
            }
            .onChange(of: language) { start() }
          }
        }
      }
      .navigationTitle(.score(game.score))
      .navigationBarTitleDisplayMode(.inline)
    }
    .scrollContentBackground(.hidden)
  }

  @State var language: Language = .english
  @State var limit: Double?
  @State var game = Game("universal", language: .english, limit: nil)

  @Dependency(\.words.new) var new

  @Environment(\.modelContext) var context
}

extension AnagramsView {
  var score: Int { game.score }
  var countdown: Double? { game.limit.flatMap { $0 - game.time } }
  var outOfTime: Bool { game.limit.flatMap { $0 < game.time } ?? false }

  func start(_ root: String? = nil) {
    game = Game(root ?? new(language.locale), language: language, limit: limit)
  }
}

#Preview {
  AnagramsView()
    .modelContainer(for: Game.self, inMemory: true)
}
