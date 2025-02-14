//	Created by Leopold Lemmermann on 07.12.22.

import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct AsyncButton<Label: View, Indicator: View>: View {
  public enum IndicatorStyle: Equatable {
    case replace, edge(Edge), none
  }

  let indicatorStyle: IndicatorStyle
  let taskPriority: TaskPriority?
  let action: () async -> Void
  let label: () -> Label
  let indicator: () -> Indicator

  public var body: some View {
    Button { Task(priority: taskPriority, operation: asyncAction) } label: {
      if case let .edge(edge) = indicatorStyle {
        VStack {
          if isExecuting, edge == .top {
            indicator()
            Spacer()
          }
          
          HStack {
            if isExecuting, edge == .leading {
              indicator()
              Spacer()
            }
            
            label()
            
            if isExecuting, edge == .trailing {
              Spacer()
              indicator()
            }
          }
          
          if isExecuting, edge == .bottom {
            Spacer()
            indicator()
          }
        }
      } else {
        label()
      }
    }
    .if(isExecuting && indicatorStyle == .replace) { $0
      .hidden()
      .overlay(content: indicator)
    }
  }

  @State private var isExecuting = false

  public init(
    indicatorStyle: IndicatorStyle = .none,
    taskPriority: TaskPriority? = nil,
    action: @escaping () async -> Void,
    @ViewBuilder label: @escaping () -> Label,
    @ViewBuilder indicator: @escaping () -> Indicator = ProgressView.init
  ) {
    self.indicatorStyle = indicatorStyle
    self.taskPriority = taskPriority
    self.action = action
    self.label = label
    self.indicator = indicator
  }

  @Sendable func asyncAction() async {
    isExecuting = true
    await action()
    isExecuting = false
  }
}
