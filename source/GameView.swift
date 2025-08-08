// Created by Leopold Lemmermann on 06.08.25.

import Words
import SwiftUI

public struct GameView: View {
  let game: Game

  public var body: some View {
    VStack {
      WordList(game.words)
        .notification(.wordAlertTitle, item: $wordAlert)

      SubmittableTextField(.enterWord(game.root), text: $newWord, submittable: isValidWord) {
        addWord()
        focussingWord = true
      }
      .focused($focussingWord)
      .textFieldStyle(.roundedBorder)
      .padding()
      .onAppear { focussingWord = true }
    }
  }

  @FocusState var focussingWord: Bool
  @State var wordAlert: LocalizedStringResource?
  @State var newWord = ""

  @Dependency(\.words.exists) var exists
}

extension GameView {
  var isValidWord: Bool {
    wordIsNotRoot && wordIsLongEnough && wordIsNew && wordExists && wordIsInRoot
  }
  var wordIsNotRoot: Bool { newWord != game.root }
  var wordIsLongEnough: Bool { newWord.count > 3 }
  var wordIsNew: Bool { !game.words.contains(newWord) }
  var wordExists: Bool { exists(newWord, game.language.locale) }
  var wordIsInRoot: Bool {
    var rootSet: Set<Character> = Set(game.root)
    for character in newWord {
      if rootSet.remove(character) == nil {
        return false
      }
    }
    return true
  }
}

extension GameView {
  func addWord() {
    guard isValidWord else {
      return wordAlert = switch false {
      case wordIsNotRoot: .wordAlertIsRoot
      case wordIsLongEnough: .wordAlertLength
      case wordIsNew: .wordAlertNotNew
      case wordIsInRoot: .wordAlertNotInRoot(game.root)
      case wordExists: .wordAlertExists(newWord)
      default: nil
      }
    }

    game.words.append(newWord)
    newWord = ""
  }
}

#Preview {
  GameView(game: Game("hello", language: .english, limit: nil))
}
