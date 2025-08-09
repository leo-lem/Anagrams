// Created by Leopold Lemmermann on 06.08.25.

import Model
import Words
import SwiftUI
import SwiftData

public struct GameView: View {
  public let game: LocalGame

  public var body: some View {
    VStack {
      WordList(game.words)
        .notification(.wordAlertTitle, item: $wordAlert)

      SubmittableTextField(.whatWordCanBeMade, text: $newWord, submittable: isValidWord) {
        addWord()
        focussingWord = true
      }
      .focused($focussingWord).onAppear { focussingWord = true }
      .textFieldStyle(.roundedBorder)
      .padding()
    }
    .toolbar {
      if AnagramsApp.enableTimer {
        ToolbarItem(placement: .topBarLeading) {
          if game.limit != nil {
            Text(game.countdown)
              .foregroundStyle(game.outOfTime ? .red : .primary)
          }
        }
      }
    }
    .onChange(of: game.words) {
      if !$1.isEmpty { game.save(to: context) }
    }

  }

  @State var newWord = ""
  @State var wordAlert: LocalizedStringResource?
  @FocusState var focussingWord: Bool

  @Environment(\.modelContext) var context
  @Dependency(\.words.exists) var exists

  public init(_ game: LocalGame) {
    self.game = game
  }
}

extension GameView {
  var isValidWord: Bool {
    wordIsNotRoot && wordIsLongEnough && wordIsNew && wordExists && wordIsInRoot
  }
  var wordIsNotRoot: Bool { newWord != game.root }
  var wordIsLongEnough: Bool {
    newWord.count >= Bundle.main.object(forInfoDictionaryKey: "MinGuessLength") as? Int ?? 1
  }
  var wordIsNew: Bool { !game.words.contains(newWord) }
  var wordExists: Bool { exists(newWord, game.language) }
  var wordIsInRoot: Bool {
    var rootChars: [Character] = game.root.map { $0 }
    for character in newWord {
      if let index = rootChars.firstIndex(of: character) {
        rootChars.remove(at: index)
      } else {
        return false
      }
    }
    return true
  }

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
  GameView(.example)
}
