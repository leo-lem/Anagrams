// Created by Leopold Lemmermann on 15.12.22.

import Foundation

extension Bool {
  var nsPredicate: NSPredicate { NSPredicate(value: self) }
}
