// Created by Leopold Lemmermann on 08.08.25.

import SwiftUI

public struct GameSummary: View {
  let game: Game

  public var body: some View {
    VStack {
      VStack(spacing: 20) {
        Label(.rootWord(game.root), systemImage: "textformat")
        Label("Language: \(game.language.localized)", systemImage: "globe")
        Label(.wordsFound(game.count), systemImage: "list.bullet.rectangle")
        Label(.scorePoints(game.score), systemImage: "star.fill")
        if let limit = game.limit {
          Label(.timeLimitSec(Int(limit)), systemImage: "timer")
        }
        Label(.timeUsedSec(Int(game.time)), systemImage: "clock")
      }
      .padding()
      .font(.headline.bold())
      .background(Color.background, in: RoundedRectangle(cornerRadius: 10))

      Section(.words) {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
          if game.words.isEmpty {
            Text(.noneFound)
              .foregroundStyle(.secondary)
          } else {
            ForEach(game.words, id: \.self) { word in
              Text(word)
                .padding()
                .background(Color.background, in: .capsule)
            }
          }
        }
      }
      .padding()

      Spacer()
    }
    .foregroundStyle(.text)
    .background(Background())
    .navigationTitle(.gameSummary)
  }
}

#Preview {
  NavigationStack {
    GameSummary(game: .example)
  }
}
