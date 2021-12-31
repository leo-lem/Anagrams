//
//  Persistence.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 30.12.21.
//

import Foundation
import CoreData
import CloudKit

//TODO: Publish the Leaderboard to a public CK database and have all users share the same leaderboard
struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Leaderboard")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Core Data could not be loaded: \(error.localizedDescription)")
            }
        }
        
        let desc = container.persistentStoreDescriptions.first
        let url = desc?.url?.deletingLastPathComponent()
        let publicDesc = NSPersistentStoreDescription(url: url!.appendingPathComponent("public.sqlite"))
        let publicOpt = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.LeoLem.WordScramble")
        
        publicOpt.databaseScope = .public
        publicDesc.cloudKitContainerOptions = publicOpt
        publicDesc.configuration = "Public"
        publicDesc.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        publicDesc.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.persistentStoreDescriptions = [publicDesc]
    }
    
    func initCKSchema() {
        do {
            try container.initializeCloudKitSchema(options: NSPersistentCloudKitContainerSchemaInitializationOptions())
        } catch {
            print("\n\n\n\n\nSomething went wrong with initializing the CloudKit Schema: \(error)\n\n\n\n\n")
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Saving CoreData Context failed: \(error.localizedDescription)")
            }
        }
    }
}
