//	Created by Leopold Lemmermann on 01.12.22.

import protocol Foundation.LocalizedError

public extension LocalizedError {
  var hasDescription: Bool { self.errorDescription != nil }
}
