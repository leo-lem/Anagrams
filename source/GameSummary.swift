// Created by Leopold Lemmermann on 08.08.25.

import Model
import CKClient
import SwiftUI

public struct GameSummary: View {
  public let game: any Game

  public var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: 20) {
        if let sharedGame = game as? SharedGame {
          Label(.player(sharedGame.name), systemImage: "person.circle")
        }

        Label(.rootWord(game.root), systemImage: "textformat")
        Label(.language(game.language.localized), systemImage: "globe")
        Label(.scorePoints(game.score), systemImage: "star.fill")

        if let localGame = game as? LocalGame {
          Label(.wordsFound(localGame.count), systemImage: "list.bullet.rectangle")

          if AnagramsApp.enableTimer {
            if let limit = localGame.limit {
              Label(.timeLimitSec(limit), systemImage: "timer")
            }
            Label(.timeUsedSec(localGame.time), systemImage: "clock")
          }
        }
      }
      .font(.headline.bold())
      .padding()
      .background(Color.background, in: RoundedRectangle(cornerRadius: 10))
      .frame(maxWidth: .infinity)

      if let localGame = game as? LocalGame {
        Section(.words) {
          if localGame.words.isEmpty {
            Text(.noneFound)
              .foregroundStyle(.secondary)
          } else {

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
              ForEach(localGame.words, id: \.self) { word in
                Text(word)
                  .padding()
                  .background(Color.background, in: .capsule)
              }
            }
          }
        }
        .padding()
      }

      Spacer()
    }
    .foregroundStyle(.text)
    .background(Background())
    .navigationTitle(.gameSummary)
  }

  public init(_ game: any Game) { self.game = game }
}

#Preview {
  NavigationStack {
    GameSummary(LocalGame.example)
  }
}

#Preview("No words") {
  NavigationStack {
    GameSummary(LocalGame("hello", language: .english, limit: nil))
  }
}

#Preview("Shared") {
  NavigationStack {
    GameSummary(SharedGame.example)
  }
}
