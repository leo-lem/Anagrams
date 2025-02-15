// Created by Leopold Lemmermann on 14.02.25.

import Dependencies
import Foundation
import Testing
import Types
@testable import Words

struct Test {
  @Dependency(\.words) var words

  @Test(arguments: Locale.Language.supported)
  func givenSupportedLanguages_whenGettingNewWord_thenIsReturned(language: Locale.Language) async throws {
    withDependencies { $0.words = .liveValue } operation: {
      #expect(words.new(language) != nil)
    }
  }

  @Test(arguments: Locale.Language.supported)
  func givenSupportedLanguages_whenGettingNewWord_thenExists(language: Locale.Language) async throws {
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

  @Test(arguments: ["a", "lkaf", "asdf", "asdfasdf", "asdfasdfasdf"])
  func givenSupportedLanguage_whenTestingNonexistingWord_thenReturnsFalse(word: String) async throws {
    withDependencies { $0.words = .liveValue } operation: {
      #expect(!words.exists(word, .english))
    }
  }
}
