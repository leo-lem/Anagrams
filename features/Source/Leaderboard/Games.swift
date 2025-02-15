//  Created by Leopold Lemmermann on 15.01.22.

import Foundation

struct User: Codable {
    let id: UUID, joinedOn: Date

    var game: Game? = nil, entries: [Entry] = []

    var isGuest: Bool { self.credentials == nil }
    static let guest = User()
}

