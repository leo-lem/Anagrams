//	Created by Leopold Lemmermann on 04.12.22.

public protocol EventDriver {
  associatedtype Event
  
  var eventPublisher: Publisher<Event> { get }
}
