// Created by Leopold Lemmermann on 08.08.25.

import SwiftUI

public struct GameSummary: View {
  let game: Game

  public var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(Color.background)

      VStack(alignment: .leading, spacing: 20) {
        Text("Game Summary")
          .font(.title.bold())
          .foregroundStyle(.text)
          .frame(maxWidth: .infinity, alignment: .leading)

        VStack(alignment: .leading, spacing: 10) {
          Label("Root Word: \(game.root)", systemImage: "textformat")
          Label("Language: \(game.language.localized)", systemImage: "globe")
          Label("Words Found: \(game.count)", systemImage: "list.bullet.rectangle")
          Label("Score: \(game.score)", systemImage: "star.fill")
          if let limit = game.limit {
            Label("Time Limit: \(Int(limit)) sec", systemImage: "timer")
          }
          Label("Time Used: \(Int(game.time)) sec", systemImage: "clock")
        }
        .font(.subheadline.weight(.medium))
        .foregroundStyle(.text)
        .labelStyle(.titleAndIcon)
        .padding()
        .background(.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

        Divider()
        VStack(alignment: .leading, spacing: 12) {
          Text("Words")
            .font(.headline)
            .foregroundStyle(.text)

          if game.words.isEmpty {
            Text("None found.")
              .foregroundStyle(.secondary)
          } else {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 12)], spacing: 12) {
              ForEach(game.words, id: \.self) { word in
                Text(word).bold()
                  .foregroundStyle(.text)
                  .padding()
                  .background(Color.secondaryBackground)
                  .clipShape(Capsule())
              }
            }
          }
        }
        .padding()

        Spacer()
      }
      .padding()
    }
    .background(Background())
  }
}

#Preview {
  GameSummary(game: .example)
}
