// Created by Leopold Lemmermann on 19.02.25.

import SwiftUI

/// A TextField with a submit button.
public struct SubmittableTextField: View {
  @Binding var text: String
  let label: LocalizedStringResource
  /// Submit will be executed regardless of submittable property.
  let submittable: Bool,
      submit: () -> Void

  public var body: some View {
    HStack {
      Group {
        if #available(iOS 26.0, *) {
          TextField(label, text: $text)
        } else {
          TextField(LocalizedStringKey(stringLiteral: label.key), text: $text)
        }
      }
      .disableAutocorrection(true)
      .textInputAutocapitalization(.never)
      .onSubmit(submit)

      Button(.submit, systemImage: submittable ? "checkmark" : "xmark", action: submit)
        .font(nil)
        .labelStyle(.iconOnly)
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .tint(submittable ? .accent : .red)
    }
    .accessibilityElement()
    .accessibilityAddTraits(.isButton)
    .accessibilityLabel(label)
    .accessibilityAction(named: .submit, submit)
  }

  public init(
    raw label: String, text: Binding<String>, submittable: Bool, submit: @escaping () -> Void
  ) {
    self.init(LocalizedStringResource(stringLiteral: label), text: text, submittable: submittable, submit: submit)
  }

  public init(
    _ label: LocalizedStringResource, text: Binding<String>, submittable: Bool, submit: @escaping () -> Void
  ) {
    _text = text
    self.label = label
    self.submittable = submittable
    self.submit = submit
  }
}

#Preview {
@Previewable @State var text = ""
  @Previewable @State var submittable = true

  SubmittableTextField(
    "Enter text",
    text: $text,
    submittable: submittable,
    submit: { submittable.toggle() }
  )
  .textFieldStyle(.roundedBorder)
}
