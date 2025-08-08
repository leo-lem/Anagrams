// Created by Leopold Lemmermann on 07.08.25.

import CloudKit

public struct LeaderboardEntry: Identifiable {
  public let id: CKRecord.ID
  public let name: String
  public let root: String
  public let score: Int
  public let date: Date

  public init(record: CKRecord) {
    self.id = record.recordID
    self.name = record["name"] as? String ?? "Anonymous"
    self.root = record["root"] as? String ?? ""
    self.score = record["score"] as? Int ?? 0
    self.date = record["date"] as? Date ?? Date()
  }

  public func toRecord() -> CKRecord {
    let record = CKRecord(recordType: "LeaderboardEntry")
    record["name"] = name as NSString
    record["root"] = root as NSString
    record["score"] = score as NSNumber
    record["date"] = date as NSDate
    return record
  }
}
