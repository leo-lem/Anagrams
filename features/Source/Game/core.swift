// Created by Leopold Lemmermann on 15.02.25.

import ComposableArchitecture
import Database
import Foundation
import Types
import Words

@Reducer public struct Singleplayer {
  @ObservableState public struct State: Equatable {
    @Shared var roots: [String]
    var newRoot: String
    var newWord: String

    var game: SingleplayerGame

    var rootAlert: String?
    var wordAlert: String?

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
    case complete
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
          state.rootAlert = switch false {
          case state.rootIsLongEnough: String(localizable: .rootAlertLength)
          case state.rootExists: String(localizable: .rootAlertExists)
          default: nil
          }
          return .concatenate(
            .cancel(id: "rootAlert"),
            .run { send in
              @Dependency(\.continuousClock) var clock
              try? await clock.sleep(for: .seconds(2))
              await send(.view(.binding(.set(\.rootAlert, nil))))
            }.cancellable(id: "rootAlert")
          )
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
          state.wordAlert = switch false {
          case state.wordIsNotRoot: String(localizable: .wordAlertIsRoot)
          case state.wordIsLongEnough: String(localizable: .wordAlertLength)
          case state.wordIsNew: String(localizable: .wordAlertNotNew)
          case state.wordIsInRoot: String(localizable: .wordAlertNotInRoot(state.game.root))
          case state.wordExists: String(localizable: .wordAlertExists(state.newWord))
          default: nil
          }
          return .concatenate(
            .cancel(id: "wordAlert"),
            .run { send in
              @Dependency(\.continuousClock) var clock
              try? await clock.sleep(for: .seconds(2))
              await send(.view(.binding(.set(\.wordAlert, nil))))
            }.cancellable(id: "wordAlert")
          )
        }

        state.game.words.append(state.newWord)
        state.newWord = ""
        return .none

      case .tick:
        state.game.time += .seconds(1)
        return .none

      case .complete:
        return .none
//        return .run { [game = state.game] _ in
//          @Dependency(\.games) var games
//          try await games.add(game)
//        } catch: { error, _ in
//          print("Error saving game: \(error)")
//        }

      case let .view(action):
        switch action {
        case .saveButtonTapped:
          return .send(.complete)

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

  public var isValidRoot: Bool { rootIsLongEnough && rootExists }
  fileprivate var rootIsLongEnough: Bool { newRoot.count > 5 }
  fileprivate var rootExists: Bool {
    @Dependency(\.words.exists) var exists
    return exists(newRoot, game.language)
  }

  public var isValidWord: Bool { wordIsNotRoot && wordIsLongEnough && wordIsNew && wordExists && wordIsInRoot }
  fileprivate var wordIsNotRoot: Bool { newWord != game.root }
  fileprivate var wordIsLongEnough: Bool { newWord.count > 1 }
  fileprivate var wordIsNew: Bool { !game.words.contains(newWord) }
  fileprivate var wordExists: Bool {
    @Dependency(\.words.exists) var exists
    return exists(newWord, game.language)
  }
  fileprivate var wordIsInRoot: Bool { newWord.allSatisfy(game.root.contains) }
}
