// Created by Leopold Lemmermann on 06.08.25.

import Model
import Words
import SwiftUI
import SwiftUIExtensions

public struct AnagramsView: View {
  public var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Button(.previous, systemImage: "chevron.left", action: previous)
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)
            .disabled(gameIndex <= 0)

          RootPicker(Binding { root ?? game.root } set: { root = $0 }, language: language)
            .onChange(of: game) { root = nil }

          Button(.next, systemImage: "chevron.right", action: next)
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)
        }
        .padding()

        GameView(game)
          .disabled(game.outOfTime)
      }
      .background(Background())
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Menu(.settings, systemImage: "gear") {
            if AnagramsApp.enableTimer {
              Button(minuteLimit == nil ? .timerOn : .timerOff, systemImage: "timer") {
                minuteLimit = minuteLimit != nil ? nil
                : Bundle.main.object(forInfoDictionaryKey: "DefaultTimeLimitMins") as? Double
              }
              .onChange(of: minuteLimit) {
                if let minuteLimit {
                  game.limit = Int(minuteLimit) * 60
                } else {
                  next()
                }
              }

              if let minuteLimit {
                Slider(
                  value: Binding { minuteLimit } set: { self.minuteLimit = $0 },
                  in: 1...60,
                  step: 1
                ) {
                  Label(.timeLimitMinutes(Int(minuteLimit)), systemImage: "clock")
                }
              }
            }

            Picker(.language, selection: $language) {
              ForEach(Language.allCases, id: \.self) { language in
                Text(language.localized)
                  .tag(language)
              }
            }
            .onChange(of: language) { next() }
          }
        }

        ToolbarItem(placement: .confirmationAction) {
          NavigationLink {
            LeaderboardView()
              .background { Background() }
          } label: {
            Label(.leaderboard, systemImage: "trophy")
          }
        }
      }
      .navigationTitle(.score(game.score))
      .navigationBarTitleDisplayMode(.inline)
    }
    .scrollContentBackground(.hidden)
  }

  @State var root: String?
  @State var language: Language
  @State var minuteLimit: Double?

  @State var game: LocalGame
  @State var games: [LocalGame]

  @Dependency(\.words.new) var new

  public init(_ startGame: LocalGame = LocalGame()) {
    game = startGame
    games = [startGame]
    language = startGame.language
  }
}

extension AnagramsView {
  var gameIndex: Int { games.firstIndex(of: game) ?? 0 }

  var score: Int { game.score }

  func previous() {
    guard gameIndex > 0 else { return }
    game = games[gameIndex - 1]
  }

  func next() {
    if gameIndex >= games.count - 1 {
      game = LocalGame(root ?? new(language), language: language, limit: minuteLimit.flatMap { Int($0) * 60 })
      games.append(game)
    } else {
      game = games[gameIndex + 1]
    }
  }
}

#Preview {
  AnagramsView()
    .modelContainer(for: LocalGame.self, inMemory: true)
}
