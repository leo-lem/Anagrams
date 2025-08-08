// Created by Leopold Lemmermann on 08.08.25.

import Foundation
import Model
import CloudKit

public struct SharedGame: Game {
  public static let recordType = "SharedGame"

  public var id: CKRecord.ID?
  public var name: String
  public var root: String
  public var language: Language
  public var timestamp: Date
  public var score: Int

  public init(_ game: any Game, name: String) {
    self.name = name
    root = game.root
    language = game.language
    timestamp = game.timestamp
    score = game.score
  }

  public init(record: CKRecord) {
    self.id = record.recordID
    self.name = record["name"] as? String ?? ""
    self.root = record["root"] as? String ?? ""
    self.language = (record["language"] as? String).flatMap(Language.init) ?? .english
    self.timestamp = record["timestamp"] as? Date ?? .now
    self.score = record["score"] as? Int ?? 0
  }

  public func toRecord() -> CKRecord {
    let record = if let id {
      CKRecord(recordType: Self.recordType, recordID: id)
    } else {
      CKRecord(recordType: Self.recordType)
    }
    record["name"] = name as NSString
    record["root"] = root as NSString
    record["score"] = score as NSNumber
    record["timestamp"] = timestamp as NSDate
    return record
  }
}
