// Created by Leopold Lemmermann on 06.08.25.

import SwiftUI
import SwiftData

public struct LeaderboardView: View {
  @Query var games: [Game]

  public var body: some View {
    List(games.sorted(by: \.score, using: >)) { game in
      VStack(alignment: .leading) {
        HStack {
          Text(game.root)
            .font(.headline)
          Spacer()
          Text("\(game.score) points")
            .bold()
        }
        if let date = game.completedAt {
          Text(date.formatted(date: .abbreviated, time: .shortened))
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        Text("\(game.count) words")
          .font(.caption2)
      }
      .padding(.vertical, 4)
    }
    .navigationTitle(.leaderboard)
  }
}

#Preview {
  LeaderboardView()
    .modelContainer(for: Game.self, inMemory: true)
}
