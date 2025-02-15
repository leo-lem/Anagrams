// Created by Leopold Lemmermann on 14.02.25.

import ComposableArchitecture
import Foundation
import Types

@Reducer public struct Preferences {
  @ObservableState public struct State: Equatable {
    @Shared public var language: Locale.Language
    @Shared public var limit: Duration?

    var limitSeconds: Int {
      get { Int(limit?.components.seconds ?? 0) }
      set {
        $limit.withLock {
          $0 = newValue > 0 ? .seconds(newValue) : nil
        }
      }
    }

    public init(
      language: Locale.Language = .english,
      limit: Duration = .seconds(180)
    ) {
      _language = Shared(wrappedValue: language, .fileStorage(.documentsDirectory.appending(component: "language")))
      _limit = Shared(wrappedValue: limit, .fileStorage(.documentsDirectory.appending(component: "limit")))
    }
  }

  public enum Action: ViewAction, Sendable {
    case start(_ language: Locale.Language, _ limit: Duration?)
    case resume

    case view(View)
    public enum View: BindableAction, Sendable {
      case binding(BindingAction<State>)
      case startButtonTapped
      case resumeButtonTapped
    }
  }

  public var body: some Reducer<State, Action> {
    BindingReducer(action: \.view)

    Reduce { state, action in
      switch action {
      case .start:
          .none

      case .resume:
          .none
        
      case let .view(action):
        switch action {
        case .startButtonTapped:
            .send(.start(state.language, state.limit))

        case .resumeButtonTapped:
            .send(.resume)

        case .binding:
            .none
        }
      }
    }
  }

  public init() {}
}
