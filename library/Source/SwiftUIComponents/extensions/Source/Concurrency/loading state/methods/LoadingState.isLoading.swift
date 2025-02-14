//	Created by Leopold Lemmermann on 24.11.22.

public extension LoadingState {
  var isLoading: Bool {
    if case .loading = self { return true } else { return false }
  }
}
