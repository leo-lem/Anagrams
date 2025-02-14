//	Created by Leopold Lemmermann on 04.12.22.

public extension EventDriver {
  var events: AsyncStream<Event> { eventPublisher.stream }
  
  func handleEvents(with handler: (Event) async throws -> Void) async rethrows {
    for await event in events { try await handler(event) }
  }
  
  func handleEventsTask(
    _ priority: TaskPriority? = nil,
    with handler: @escaping (Event) async throws -> Void
  ) -> Task<Void, Error> {
    Task(priority: priority) { try await handleEvents(with: handler) }
  }
}
