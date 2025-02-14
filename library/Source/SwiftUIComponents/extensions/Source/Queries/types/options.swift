//	Created by Leopold Lemmermann on 25.10.22.

public extension Query {
  struct Options: Equatable {
    /// The maximum number of items to be fetched
    public let maxItems: Int?
    
    /// The number of items to be fetched at a time (when fetching asynchronously)
    public let batchSize: Int

    public init(
      maxItems: Int? = nil,
      batchSize: Int = 1
    ) {
      self.maxItems = maxItems
      self.batchSize = batchSize
    }
  }
}
