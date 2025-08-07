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
        startValid()
      }
      .labelStyle(.iconOnly)
      .disabled(focussingRoot || !previousAvailable)

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
        SubmittableTextField(root, text: $newRoot, submittable: isValidRoot, submit: startValid)
          .focused($focussingRoot)
          .font(.largeTitle)
          .padding()
      }

      Button(.next, systemImage: "chevron.right") {
        start(new(language.locale))
      }
      .labelStyle(.iconOnly)
      .disabled(focussingRoot)
    }
    .notification(.rootAlertTitle, item: $rootAlert)
    .onChange(of: root) { newRoot = "" }
  }

  @State var newRoot = ""
  @State var editingRoot = false
  @State var roots = [String]()
  @State var rootAlert: LocalizedStringResource?
  @FocusState var focussingRoot: Bool

  @Dependency(\.words.new) var new
  @Dependency(\.words.exists) var exists
}

extension RootSelecter {
  var isValidRoot: Bool { rootIsLongEnough && rootExists }
  var rootIsLongEnough: Bool { newRoot.count > 4 }
  var rootExists: Bool { exists(newRoot, language.locale) }

  var previousAvailable: Bool {
    roots.firstIndex(of: root) ?? 0 > 0
  }

  func startValid() {
    guard isValidRoot else {
      return rootAlert = switch false {
      case rootIsLongEnough: .rootAlertLength
      case rootExists: .rootAlertExists
      default: nil
      }
    }

    roots += [root]
    editingRoot = false
    start(newRoot)
  }
}
