// Created by Leopold Lemmermann on 14.02.25.

import Dependencies
import Foundation
import Model
import Testing
@testable import Words

@MainActor
struct Test {
  @Dependency(\.words) var words

  @Test(arguments: Language.allCases)
  func givenSupportedLanguages_whenGettingNewWord_thenIsReturned(language: Language) async throws {
    withDependencies { $0.words = .liveValue } operation: {
      #expect(!words.new(language).isEmpty)
    }
  }

  @Test(arguments: Language.allCases)
  func givenSupportedLanguages_whenGettingNewWord_thenExists(language: Language) async throws {
    withDependencies { $0.words = .liveValue } operation: {
      #expect(words.exists(words.new(language), language))
    }
  }

  @Test(arguments: ["hello", "world", "swift", "test", "apple"])
  func givenSupportedLanguage_whenTestingExistingWord_thenReturnsTrue(word: String) async throws {
    withDependencies { $0.words = .liveValue } operation: {
      #expect(words.exists(word, .english))
    }
  }

  @Test(arguments: ["lkaf", "lkaso", "asdfasdf", "asdfasdfasdf"])
  func givenSupportedLanguage_whenTestingNonexistingWord_thenReturnsFalse(word: String) async throws {
    withDependencies { $0.words = .liveValue } operation: {
      #expect(!words.exists(word, .english))
    }
  }
}
