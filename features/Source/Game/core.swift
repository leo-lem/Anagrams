// Created by Leopold Lemmermann on 15.02.25.

import ComposableArchitecture
import Foundation
import Types
import Words

@Reducer public struct Singleplayer {
  @ObservableState public struct State: Equatable {
    @Shared var roots: [String]
    var newRoot: String
    var newWord: String

    var game: SingleplayerGame

    public init(
      roots: [String] = [],
      root: String? = nil,
      language: Locale.Language,
      limit: Duration?,
      words: [String] = [],
      time: Duration = .zero,
      newRoot: String = "",
      newWord: String = ""
    ) {
      @Dependency(\.words.new) var new
      _roots = Shared(wrappedValue: roots, .inMemory("roots"))
      self.game = SingleplayerGame(root ?? new(language), language: language, limit: limit, words: words, time: time)
      self.newRoot = newRoot
      self.newWord = newWord
    }
  }

  public enum Action: ViewAction, Sendable {
    case save(_ game: SingleplayerGame)
    case start
    case addWord
    case tick

    case view(View)
    public enum View: BindableAction, Sendable {
      case binding(BindingAction<State>)
      case saveButtonTapped
      case newRootSubmitted
      case previousRootTapped
      case newWordSubmitted
      case menuTapped
      case appeared
    }
  }

  public var body: some Reducer<State, Action> {
    BindingReducer(action: \.view)

    Reduce { state, action in
      switch action {
      case .start:
        guard state.isValidRoot else {
          // TODO: show alert
          return .none
        }

        state.game = SingleplayerGame(state.newRoot, language: state.game.language, limit: state.game.limit)
        state.newRoot = ""
        state.newWord = ""
        state.$roots.withLock {
          if !$0.contains(state.game.root) {
            $0 += [state.game.root]
          }
        }
        return .none

      case .addWord:
        guard state.isValidWord else {
          // TODO: show alert
          return .none
        }
        state.game.words.append(state.newWord)
        state.newWord = ""
        return .none

      case .tick:
        state.game.time += .seconds(1)
        return .none

      case let .view(action):
        switch action {
        case .saveButtonTapped:
          return .send(.save(state.game))

        case .newRootSubmitted:
          return .send(.start)

        case .previousRootTapped:
          state.$roots.withLock { _ = $0.removeLast() }
          state.newRoot = state.roots.last ?? state.game.root
          return .send(.start)

        case .newWordSubmitted:
          return .send(.addWord)

        case .appeared:
          state.$roots.withLock { $0.append(state.game.root) }
          return .run { send in
            @Dependency(\.continuousClock) var clock
            for await _ in clock.timer(interval: .seconds(1)) { await send(.tick) }
          }
          
        case .menuTapped: return .none
        case .binding: return .none
        }

      case .save:
        return .none
      }
    }
  }

  public init() {}
}

extension Singleplayer.State {
  public var score: Int { game.score }
  public var countdown: Duration? { game.limit.flatMap { $0 - game.time } }
  public var outOfTime: Bool { game.limit.flatMap { $0 < game.time } ?? false }

  public var previousAvailable: Bool {
    roots.firstIndex(of: game.root) ?? 0 > 0
  }

  public var isValidRoot: Bool {
    @Dependency(\.words.exists) var exists
    return newRoot.count > 5
    && exists(newRoot, game.language)
  }

  public var isValidWord: Bool {
    @Dependency(\.words.exists) var exists
    return newWord != game.root
    && newWord.count > 1
    && !game.words.contains(newWord)
    && exists(newWord, game.language)
    && newWord.allSatisfy(game.root.contains)
  }
}
