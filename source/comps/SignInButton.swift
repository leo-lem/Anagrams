// Created by Leopold Lemmermann on 07.08.25.

import CKClient
import SwiftUI
import SwiftUIExtensions

public struct SignInButton: View {
  @Binding var username: String?

  public var body: some View {
    AsyncButton {
      if username == nil {
        if await isAvailable() {
          signingIn = true
        } else {
          showSettingsPrompt = true
        }
      } else {
        signingOut = true
      }
    } label: {
      Label(
        username ?? "Sign In",
        systemImage: "person.crop.circle.\(username == nil ? "badge.plus" : "fill.badge.checkmark")"
      )
    }
    .alert(.enterYourUsername, isPresented: $signingIn) {
      TextField(LocalizedStringKey(LocalizedStringResource.username.key), text: $newUsername)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()

      Button(.ok) { username = newUsername }
      Button(.cancel, role: .cancel) {}
    }
    .alert(.signOut(username ?? ""), isPresented: $signingOut) {
      Button(.signOut, role: .destructive) { username = nil }
    }
    .alert(.iCloudUnavailable, isPresented: $showSettingsPrompt) {
      Button(.settings) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
      }
      Button(.cancel, role: .cancel) {}
    } message: {
      Text(.pleaseSignInToYourICloudAccountToEnableLeaderboardFeatures)
    }
  }

  @State var signingIn = false
  @State var signingOut = false
  @State var newUsername = ""
  @State private var showSettingsPrompt = false

  @Dependency(\.cloudkit.isAvailable) var isAvailable

  public init(_ username: Binding<String?>) {
    _username = username
  }
}

#Preview {
  @Previewable @State var username: String?

  SignInButton($username)
}
