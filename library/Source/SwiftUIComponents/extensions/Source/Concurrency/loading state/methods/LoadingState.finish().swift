//	Created by Leopold Lemmermann on 15.11.22.

public extension LoadingState {
  mutating func finish(throwing: (Self) throws -> () = { _ in }) {
    do {
      try throwing(self)
      self = .loaded(wrapped ?? [])
    } catch {
      self = .failed(error.localizedDescription)
    }
  }

  @_disfavoredOverload
  mutating func finish(throwing: (Self) async throws -> () = { _ in }) async {
    do {
      try await throwing(self)
      self = .loaded(wrapped ?? [])
    } catch {
      self = .failed(error.localizedDescription)
    }
  }
}
