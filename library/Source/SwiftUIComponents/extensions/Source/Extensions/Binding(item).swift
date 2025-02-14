//	Created by Leopold Lemmermann on 06.11.22.

import SwiftUI

public extension Binding where Value == Bool {
  init<T>(item: Binding<T?>, defaultValue: T? = nil) {
    self.init { item.wrappedValue != nil } set: { newValue in
      item.wrappedValue = newValue ? defaultValue : nil
    }
  }
}
