//	Created by Leopold Lemmermann on 04.12.22.

import class Combine.PassthroughSubject

public extension EventDriver {
  typealias Publisher<Event> = PassthroughSubject<Event, Never>
}
