// Created by Leopold Lemmermann on 15.02.25.

import Foundation

public protocol Game: Equatable {
  var root: String { get }
  var language: Language { get }
  var timestamp: Date { get }
  var score: Int { get }
}
