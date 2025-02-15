// Created by Leopold Lemmermann on 15.02.25.

import ComposableArchitecture
import Database
import Game
import Preferences
import Types

@Reducer public struct Anagrams {
  @ObservableState public struct State {
    var preferences: Preferences.State
    @Presents var games: Games.State?

    public init(
      preferences: Preferences.State = Preferences.State(),
      game: Singleplayer.State? = nil
    ) {
      self.preferences = preferences
      self.games = game.flatMap { .single($0) }
    }
  }

  public enum Action {
    case preferences(Preferences.Action)
    case games(PresentationAction<Games.Action>)
  }

  @Reducer
  public enum Games {
    case single(Singleplayer)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.preferences, action: \.preferences, child: Preferences.init)

    Reduce { state, action in
      switch action {
      case let .preferences(.start(language, limit)):
        state.games = .single(Singleplayer.State(language: language, limit: limit))
        return .none

      case .preferences(.resume):
        return .none

      case .games(.presented(.single(.complete))):
        state.games = nil
        return .none

      case .preferences:
        return .none

      case .games:
        return .none
      }
    }
    .ifLet(\.$games, action: \.games)
  }
}
