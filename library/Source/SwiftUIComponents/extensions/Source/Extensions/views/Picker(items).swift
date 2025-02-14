//	Created by Leopold Lemmermann on 09.10.22.

import SwiftUI

public extension Picker {
  init<S: StringProtocol, Data: RandomAccessCollection, ID: Hashable, ItemContent: View>(
    _ title: S,
    selection: Binding<SelectionValue>,
    items: Data,
    id: KeyPath<Data.Element, ID>,
    content: @escaping (Data.Element) -> ItemContent
  ) where Label == Text, Content == ForEach<Data, ID, ItemContent> {
    self.init(title, selection: selection, content: { ForEach(items, id: id, content: content) })
  }
}
