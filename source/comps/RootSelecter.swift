// Created by Leopold Lemmermann on 06.08.25.

import SwiftUI
import Words

public struct RootSelecter: View {
  let root: String
  let language: Language
  let start: (_ root: String) -> Void

  public var body: some View {
    HStack {
      Button(.previous, systemImage: "chevron.left") {
        newRoot = roots.removeLast()
        startValid(saveRoot: false)
      }
      .labelStyle(.iconOnly)
      .buttonStyle(.bordered)
      .disabled(focussingRoot || !previousAvailable)

      Spacer()

      if !editingRoot {
        Text(root)
          .lineLimit(1)
          .font(.largeTitle)
          .onLongPressGesture { editingRoot = true }
          .opacity(editingRoot ? 0 : 1)

        Toggle(.editRoot, systemImage: "pencil", isOn: $editingRoot)
          .toggleStyle(.button)
          .labelStyle(.iconOnly)
          .disabled(editingRoot)
          .padding(.leading, -15)
      } else {
        SubmittableTextField(raw: root, text: $newRoot, submittable: isValidRoot) {
          startValid()
        }
          .focused($focussingRoot)
          .font(.largeTitle)
      }

      Spacer()

      Button(.next, systemImage: "chevron.right") {
        newRoot = new(language.locale)
        startValid()
      }
      .labelStyle(.iconOnly)
      .buttonStyle(.bordered)
      .disabled(focussingRoot)
    }
    .notification(.rootAlertTitle, item: $rootAlert)
    .onChange(of: root) { newRoot = "" }
    .onChange(of: language) { roots = [] }
    .padding(.horizontal)
  }

  @State var newRoot = ""
  @State var editingRoot = false
  @State var rootAlert: LocalizedStringResource?
  @FocusState var focussingRoot: Bool

  @State var roots = [String]()

  @Dependency(\.words.new) var new
  @Dependency(\.words.exists) var exists

  init(
    root: String,
    language: Language,
    start: @escaping (_: String) -> Void
  ) {
    self.root = root
    self.language = language
    self.start = start
  }
}

extension RootSelecter {
  var isValidRoot: Bool { rootIsLongEnough && rootExists }
  var rootIsLongEnough: Bool { newRoot.count > 3 }
  var rootExists: Bool { exists(newRoot, language.locale) }

  var previousAvailable: Bool { !roots.isEmpty }

  func startValid(saveRoot: Bool = true) {
    if newRoot.isEmpty { return editingRoot = false }

    guard isValidRoot else {
      return rootAlert = switch false {
      case rootIsLongEnough: .rootAlertLength
      case rootExists: .rootAlertExists
      default: nil
      }
    }

    if saveRoot { roots += [root] }
    editingRoot = false
    start(newRoot)
  }
}

#Preview {
  @Previewable @State var root = "universal"

  RootSelecter(root: root, language: .english, start: { root = $0 })
}
