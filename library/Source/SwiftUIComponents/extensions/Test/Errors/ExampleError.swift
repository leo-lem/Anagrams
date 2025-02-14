//	Created by Leopold Lemmermann on 15.11.22.

import Foundation

enum ExampleError: Error, Equatable {
  case sumTingWong,
        sumTingElseWong
}

extension ExampleError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .sumTingWong: return "Oh no, something's wrong!"
    case .sumTingElseWong: return "Oh no, something else is wrong!"
    }
  }
}
