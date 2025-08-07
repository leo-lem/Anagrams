// Created by Leopold Lemmermann on 06.08.25.

import SwiftUI
import SwiftData

public struct LeaderboardView: View {
  @Query var games: [Game]

  public var body: some View {
    List(Array(games.sorted(by: \.score, using: >).enumerated()), id: \.element.id) { index, game in
      VStack {
        HStack {
          Label(game.root, systemImage: icon(index))
          Spacer()
          Text(.score(game.score))
            .bold()
        }

        HStack {
          if let date = game.completedAt {
            Text(date.formatted(date: .abbreviated, time: .shortened))
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Spacer()
          Text(.words(game.count))
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
      }
      .padding()
      .listRowSeparator(.hidden)
      .listRowBackground(RoundedRectangle(cornerRadius: 12).fill(Color.secondaryBackground).padding())
    }
    .listStyle(.plain)
    .navigationTitle(.leaderboard)
  }
}

extension LeaderboardView {
  func icon(_ index: Int) -> String {
    switch index {
    case 0: "star"
    case 1: "2.circle.fill"
    case 2: "3.circle.fill"
    default: "circle"
    }
  }
}

#Preview {
  LeaderboardView()
    .modelContainer(for: Game.self, inMemory: true) {
      (try? $0.get())?.mainContext.insert(Game.example)
    }
}
