// Created by Leopold Lemmermann on 07.08.25.

import CloudKit

@MainActor
public class CloudKitService: ObservableObject {
  private let database = CKContainer.default().publicCloudDatabase

  public init() {}

  public func saveEntry(name: String, root: String, score: Int, date: Date) async {
    let record = CKRecord(recordType: "LeaderboardEntry")
    record["name"] = name as NSString
    record["root"] = root as NSString
    record["score"] = score as NSNumber
    record["date"] = date as NSDate

    do {
      _ = try await database.save(record)
      #if DEBUG
      print("✅ Entry saved")
      #endif
    } catch {
      assertionFailure("❌ Error saving record: \(error.localizedDescription)")
    }
  }

  public func fetchTopEntries(limit: Int = 10) async -> [LeaderboardEntry] {
    let query = CKQuery(recordType: "LeaderboardEntry", predicate: NSPredicate(value: true))
    query.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]

    var entries: [LeaderboardEntry] = []
    do {
      let result = try await database.records(matching: query, resultsLimit: limit)
      for (_, result) in result.matchResults {
        entries.append(LeaderboardEntry(record: try result.get()))
      }
    } catch {
      assertionFailure("❌ Error fetching record: \(error.localizedDescription)")
    }

    return entries
  }
}
