// Created by Leopold Lemmermann on 06.08.25.

import Model
import SwiftUI
import Words

public struct RootPicker: View {
  @Binding public var root: String
  public let language: Language

  public var body: some View {
    HStack {
      if !editingRoot {
        Spacer()
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
        Spacer()
      } else {
        SubmittableTextField(raw: root, text: $newRoot, submittable: isValidRoot, submit: save)
          .focused($focussingRoot)
          .font(.largeTitle)
      }
    }
    .frame(height: 100)
    .notification(.rootAlertTitle, item: $rootAlert)
    .onChange(of: root) { newRoot = "" }
  }

  @State var newRoot = ""
  @State var editingRoot = false
  @State var rootAlert: LocalizedStringResource?
  @FocusState var focussingRoot: Bool

  @Dependency(\.words.new) var new
  @Dependency(\.words.exists) var exists

  init(
    _ root: Binding<String>,
    language: Language
  ) {
    _root = root
    self.language = language
  }
}

extension RootPicker {
  var rootIsLongEnough: Bool {
    newRoot.count >= Bundle.main.object(forInfoDictionaryKey: "MinRootLength") as? Int ?? 3
  }
  var rootExists: Bool { exists(newRoot, language) }
  var isValidRoot: Bool { rootIsLongEnough && rootExists }

  func save() {
    if newRoot.isEmpty { return editingRoot = false }

    guard isValidRoot else {
      return rootAlert = switch false {
      case rootIsLongEnough: .rootAlertLength
      case rootExists: .rootAlertExists
      default: nil
      }
    }

    editingRoot = false
    root = newRoot
  }
}

#Preview {
  @Previewable @State var root = "universal"

  RootPicker($root, language: .english)
}
