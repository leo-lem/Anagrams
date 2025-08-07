//  Created by Leopold Lemmermann on 15.01.22.

import Foundation

public extension Locale.Language {
  static let english = Locale.Language(identifier: "en")
  static let german = Locale.Language(identifier: "de")
  static let spanish = Locale.Language(identifier: "es")
  static let french = Locale.Language(identifier: "fr")

  static let supported: [Locale.Language] = [english, german, spanish, french]
}
