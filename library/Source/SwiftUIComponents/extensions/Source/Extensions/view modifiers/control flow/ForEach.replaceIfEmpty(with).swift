//	Created by Leopold Lemmermann on 10.11.22.

import SwiftUI

public extension ForEach where Content: View {
  @ViewBuilder func replaceIfEmpty<Replacement: View>(
    with replacement: () -> Replacement
  ) -> _ConditionalContent<Replacement, Self> {
    if self.data.isEmpty {
      replacement()
    } else {
      self
    }
  }
  
  func replaceIfEmpty(with description: LocalizedStringKey) -> _ConditionalContent<Text, Self> {
    replaceIfEmpty { Text(description) }
  }
  
  @_disfavoredOverload
  func replaceIfEmpty<S: StringProtocol>(with description: S) -> _ConditionalContent<Text, Self> {
    replaceIfEmpty { Text(description) }
  }
}
