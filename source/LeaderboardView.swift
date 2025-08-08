// Created by Leopold Lemmermann on 06.08.25.

import CKClient
import Model
import SwiftUI
import SwiftUIExtensions

public struct LeaderboardView: View {
  public var body: some View {
    List(Array(games.sorted(by: \.score, using: >).enumerated()), id: \.offset) { index, game in
      item(index, game)
        .swipeActions {
          if let local = game as? LocalGame {
            Button("Delete", systemImage: "trash") { context.delete(local) }
          } else if let shared = game as? SharedGame, shared.name == username {
            AsyncButton {
              await cloudkit.delete(shared)
            } label: {
              Label("Delete", systemImage: "trash")
            }
          }
        }
        .alert(.doYouWantToPublishYourScore, isPresented: $sharing) {
          AsyncButton {
            if let username {
              await cloudkit.share(SharedGame(game, name: username))
            }
          } label: {
            Label(.share, systemImage: "square.and.arrow.up")
          }

          Button(.cancel) {}
        }
    }
    .navigationTitle(.leaderboard)
    .task { sharedGames = await cloudkit.fetchTop(10) }
    .toolbar {
      ToolbarItem { SignInButton($username) }

      ToolbarItem(placement: .primaryAction) {
        Toggle(.toggleList, systemImage: showingShared ? "lock.fill" : "globe", isOn: $showingShared)
      }
    }
  }

  @Query var localGames: [LocalGame]
  @State var sharedGames = [SharedGame]()

  @State var showingShared = false
  @State var sharing = false
  @State var sharingIsAvailable = false

  @AppStorage("username") var username: String?

  @Environment(\.modelContext) var context
  @Dependency(\.cloudkit) var cloudkit
}

extension LeaderboardView {
  var games: [any Game] { showingShared ? sharedGames : localGames }

  func icon(_ index: Int) -> String {
    switch index {
    case 0: "star"
    case 1: "2.circle.fill"
    case 2: "3.circle.fill"
    default: "circle"
    }
  }

  func item(_ index: Int, _ game: any Game) -> some View {
    NavigationLink { GameSummary(game) } label: {
      HStack(spacing: 8) {
        Image(systemName: icon(index))

        VStack(spacing: 8) {
          HStack {
            Text(game.root)
            Spacer()
            Text(.score(game.score))
          }
          .bold()

          HStack {
            Text(game.timestamp.formatted(date: .abbreviated, time: .shortened))
            Spacer()
            if let name = (game as? SharedGame)?.name { Text(name) }
          }
          .font(.caption)
          .foregroundStyle(.secondary)
        }

        if !showingShared && username != nil {
          Button(.publish, systemImage: "square.and.arrow.up") {
            sharing = true
          }
          .buttonStyle(.borderedProminent)
          .labelStyle(.iconOnly)
        }
      }
    }
    .padding()
    .listRowSeparator(.hidden)
    .listRowBackground(RoundedRectangle(cornerRadius: 12).fill(Color.secondaryBackground).padding())
  }
}

#Preview {
  NavigationStack {
    LeaderboardView()
  }
  .modelContainer(for: LocalGame.self, inMemory: true) {
    (try? $0.get())?.mainContext.insert(LocalGame.example)
  }
}
