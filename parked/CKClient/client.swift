//  Created by Leopold Lemmermann on 14.01.22.

import CloudKit
import Extensions
import Types

public struct CKClient {
  private let container = CKContainer(identifier: Bundle.main[string: "CKContainerIdentifier"])

  public init() {}

  func connect() async throws {
    switch try await container.accountStatus() {
    case .available: return
    // TODO: handle other cases
    default: assertionFailure("Failed to connect to CloudKit.")
    }
  }

  public func login(_ credential: Credential) async -> Bool {
    if let user = await fetchCredential(credential.name) {
      let pinHash = user.value(forKey: "pinHash") as? Int
      return pinHash == credential.pinHash
    } else {
      let record = CKRecord(recordType: "credential")
      record["name"] = credential.name
      record["pinHash"] = credential.pinHash
      await save(record)
      return true
    }
  }

  public func isRegistered(_ name: String) async -> Bool {
    await fetchCredential(name) != nil
  }

  public func requiresPin(_ name: String) async -> Bool? {
    return if let credential = await fetchCredential(name) {
      credential.value(forKey: "pinHash") as? Int != nil
    } else {
      nil
    }
  }

  // sync preferences
  public func savePrefereneces(_ name: String, _ preferences: Preferences) async {
    let record = CKRecord(recordType: "preferences")
    record["name"] = name
    record["preferences"] = try? JSONEncoder().encode(preferences)
    await save(record)
  }

  public func fetchPreferences(_ name: String) async -> Preferences {

  }

  // read/write leaderboard games


  private func fetchCredential(_ name: String) async -> CKRecord? {
    await fetch(type: "credential", predicate: NSPredicate(format: "name == %@", name)).first
  }

  private func fetch(type: String, predicate: NSPredicate? = nil) async -> [CKRecord] {
    let query = await CKQuery(recordType: type, predicate: predicate ?? NSPredicate(value: true))
    do {
      let results = try await container.publicCloudDatabase.records(matching: query)
      return try results.matchResults.map { try $0.1.get() }
    } catch {
      print(error.localizedDescription)
      return []
    }
  }

  private func save(_ record: CKRecord) async {
    do {
      try await container.publicCloudDatabase.save(record)
    } catch {
      print(error.localizedDescription)
    }
  }
}


//MARK: fetching objects
extension CloudKitRepository {
    
    func fetchRecord(objectID: ObjectID) async throws -> CKRecord? {
        let predicate = NSPredicate(format: "\(objectIDSymbol) == %@", objectID)
        let record = try await fetchRecord(predicate: predicate)
        return record
    }
    
    private func fetchRecord(predicate: NSPredicate) async throws -> CKRecord? {
        let records = try await fetchRecords(predicate: predicate)
        return records.first
    }
    
    private func fetchRecords(predicate: NSPredicate) async throws -> [CKRecord] {
        let results = try await fetchResults(predicate: predicate)
        return try results.map { try $0.get() }
    }
    
    private func fetchResults(predicate: NSPredicate) async throws -> [Result<CKRecord, Error>] {
        let results = try await fetchQueryResults(predicate: predicate)
        return results.map { $0.1 }
    }
    
    private func fetchRecordIDs(predicate: NSPredicate) async throws -> [CKRecord.ID] {
        let resultsWithID = try await fetchQueryResults(predicate: predicate)
        return resultsWithID .map { $0.0 }
    }
    
    private func fetchQueryResults(predicate: NSPredicate) async throws -> [(CKRecord.ID, Result<CKRecord, Error>)] {
        let query = assembleQuery(predicate: predicate)
        let resultsWithID = try await self.database.records(matching: query)
        
        return resultsWithID.matchResults
    }
    
    private func assembleQuery(predicate: NSPredicate) -> CKQuery {
        CKQuery(recordType: self.objectSymbol, predicate: predicate)
    }
    
}


//MARK: saving objects
extension CloudKitRepository {
    
    private func saveRecords(_ records: CKRecord...) async throws {
        _ = try await self.database.modifyRecords(saving: records, deleting: [])
        
        //TODO: check if operation was successful
    }
    
}
