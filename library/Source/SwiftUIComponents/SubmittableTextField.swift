// Created by Leopold Lemmermann on 19.02.25.

/// A TextField with a submit button.
public struct SubmittableTextField: View {
  @Binding var text: String
  let label: LocalizedStringKey
  /// Submit will be executed regardless of submittable property.
  let submittable: Bool,
      submit: () -> Void

  public var body: some View {
    HStack {
      TextField(label, text: $text)
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        .onSubmit(submit)

      Button(.localizable(.submit), systemImage: submittable ? "checkmark" : "xmark", action: submit)
        .font(nil)
        .labelStyle(.iconOnly)
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .tint(submittable ? .green : .red)
    }
    .accessibilityElement()
    .accessibilityAddTraits(.isButton)
    .accessibilityLabel(label)
    .accessibilityAction(named: .localizable(.submit), submit)
  }

  public init(_ label: LocalizedStringKey, text: Binding<String>, submittable: Bool, submit: @escaping () -> Void) {
    _text = text
    self.label = label
    self.submittable = submittable
    self.submit = submit
  }
}
