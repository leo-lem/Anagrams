//  Created by Leopold Lemmermann on 15.01.22.

public struct Credential {
  public var name: String
  public var pinHash: Int?

  public var pinless: Bool { self.pinHash == nil }

  public init(name: String, pinHash: Int?) {
    self.name = name
    self.pinHash = pinHash
  }
}
