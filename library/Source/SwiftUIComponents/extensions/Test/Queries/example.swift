//	Created by Leopold Lemmermann on 24.11.22.

import Foundation

struct Example {
  let id: UUID
  var value: Int

  init(id: UUID = UUID(), value: Int = .random(in: 0 ..< 100)) {
    self.id = id
    self.value = value
  }
}
