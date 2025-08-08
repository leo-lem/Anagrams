// Created by Leopold Lemmermann on 06.08.25.

import SwiftData
import SwiftUI
import SwiftUIExtensions
import CloudKitService

public struct LeaderboardView: View {
  public var body: some View {
    Group {
      if showingPublicList {
        List(Array(publicEntries.enumerated()), id: \.element.id) { index, entry in
          self.entry(root: entry.root, score: entry.score, date: entry.date, name: entry.name, index: index)
        }
      } else {
        List(Array(games.sorted(by: \.score, using: >).enumerated()), id: \.element.id) { index, game in
          if let completedAt = game.completedAt {
            entry(root: game.root, score: game.score, date: completedAt, name: nil, index: index, share: true)
          }
        }
      }
    }
    .animation(.default, value: username)
    .listStyle(.plain)
    .navigationTitle(.leaderboard)
    .toolbar {
      ToolbarItem { SignInButton($username) }

      if username != nil {
        ToolbarItem(placement: .primaryAction) {
          AsyncButton {
            showingPublicList.toggle()
            if showingPublicList {
              publicEntries = await cloudKitService.fetchTopEntries()
            }
          } label: {
            Label(.toggleList, systemImage: showingPublicList ? "lock.fill" : "globe")
          }
        }
      }
    }
  }

  @Query var games: [Game]
  @State var publicEntries: [LeaderboardEntry] = []
  @State var showingPublicList = false

  @AppStorage("username") var username: String?

  @State var cloudKitService = CloudKitService()
}

extension LeaderboardView {
  func entry(root: String, score: Int, date: Date, name: String?, index: Int, share: Bool = false) -> some View {
    HStack(spacing: 8) {
      Image(systemName: icon(index))

      VStack(spacing: 8) {
        HStack {
          Text(root)
          Spacer()
          Text(.score(score))
        }
        .bold()

        HStack {
          Text(date.formatted(date: .abbreviated, time: .shortened))
          Spacer()
          if let name {
            Text(name)
          }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
      }

      if share, let username {
        AsyncButton {
          await cloudKitService.saveEntry(name: username, root: root, score: score, date: date)
        } label: {
          Label(.publish, systemImage: "square.and.arrow.up")
        }
        .buttonStyle(.borderedProminent)
        .labelStyle(.iconOnly)
      }
    }
    .padding()
    .listRowSeparator(.hidden)
    .listRowBackground(RoundedRectangle(cornerRadius: 12).fill(Color.secondaryBackground).padding())
  }

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
  NavigationStack {
    LeaderboardView()
  }
  .modelContainer(for: Game.self, inMemory: true) {
    (try? $0.get())?.mainContext.insert(Game.example)
  }
}
