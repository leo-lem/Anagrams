// Created by Leopold Lemmermann on 08.08.25.

import CloudKit
@_exported import Dependencies

extension CKClient: DependencyKey {
  private static let database = CKContainer.default().publicCloudDatabase

  public static let liveValue = CKClient(
    share: { game in
      do {
        _ = try await database.save(game.toRecord())
      } catch {
#if DEBUG
        print("❌ Error fetching record: \(error.localizedDescription)")
#endif
      }
    },
    fetchTop: { limit in
      let query = CKQuery(recordType: SharedGame.recordType, predicate: NSPredicate(value: true))
      query.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]

      var entries: [SharedGame] = []
      do {
        let result = try await database.records(matching: query, resultsLimit: limit)
        for (_, result) in result.matchResults {
          entries.append(SharedGame(record: try result.get()))
        }
      } catch {
#if DEBUG
        print("❌ Error fetching record: \(error.localizedDescription)")
#endif
      }
      return entries
    },
    delete: { game in
      do {
        try await database.deleteRecord(withID: game.toRecord().recordID)
      } catch {
#if DEBUG
        print("❌ Error deleting record: \(error.localizedDescription)")
#endif
      }
    },
    isAvailable: {
      (try? await CKContainer.default().accountStatus()) ?? .couldNotDetermine == .available
    }
  )

  public static let previewValue = CKClient(
    share: { print("Shared \($0.root)") },
    fetchTop: { _ in [] },
    delete: { print("Deleted \($0.root)") },
    isAvailable: { .random() }
  )
}

public extension DependencyValues {
  var cloudkit: CKClient {
    get { self[CKClient.self] }
    set { self[CKClient.self] = newValue }
  }
}
