//
//  CacheRealmStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-16.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamKit
import RealmSwift

public struct CacheRealmStore: CacheStore, Loggable {
    private let preferences: PreferencesType
    
    public init(preferences: PreferencesType) {
        self.preferences = preferences
    }
}

private extension CacheRealmStore {
    
    /// Name for isolated database per user or use anonymously
    var name: String {
        return generateName(for: preferences.get(.userID) ?? 0)
    }
    
    /// Used for referencing databases not associated with the current user
    func generateName(for userID: Int) -> String {
        return "user_\(userID)"
    }
}

private extension CacheRealmStore {
    
    var fileURL: URL? {
        return folderURL?.appendingPathComponent("\(name).realm")
    }
    
    var folderURL: URL? {
        return FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Realm")
    }
}

public extension CacheRealmStore {
    
    func configure() {
        DispatchQueue.database.sync {
            // Validate before initializing database
            guard let fileURL = fileURL, let folderURL = folderURL,
                // Skip if already set up before
                Realm.Configuration.defaultConfiguration.fileURL != fileURL else {
                    return
            }
            
            // Set the configuration used for user's Realm
            Realm.Configuration.defaultConfiguration = Realm.Configuration(
                fileURL: fileURL,
                shouldCompactOnLaunch: { totalBytes, usedBytes in
                    // Compact if the file is over X MB in size and less than 50% 'used'
                    // https://realm.io/docs/swift/latest/#compacting-realms
                    let maxSize = 100 * 1024 * 1024 //100MB
                    let shouldCompact = (totalBytes > maxSize) && (Double(usedBytes) / Double(totalBytes)) < 0.5
                    
                    if shouldCompact {
                        self.Log(warn: "Compacting Realm database.")
                    }
                    
                    return shouldCompact
                }
            )
            
            defer {
                // Attempt to initialize and clean if necessary
                do {
                    _ = try Realm()
                } catch {
                    Log(error: "Could not initialize Realm database: \(error). Deleting database and recreating...")
                    _delete(for: preferences.get(.userID) ?? 0)
                    _ = try? Realm()
                }
                
                Log(debug: "Realm database initialized at: \(fileURL).")
                Log(info: "Realm database configured for \(name).")
            }
            
            // Create default location, set permissions, and seed if applicable
            let fileManager: FileManager = .default
            guard !fileManager.fileExists(atPath: folderURL.path) else { return }

            // Set permissions for database for background tasks
            do {
                // Create directory if does not exist yet
                try fileManager.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
                
                // Decrease file protection after first open for the parent directory
                try fileManager.setAttributes(
                    [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication],
                    ofItemAtPath: folderURL.path
                )
            } catch {
                Log(error: "Could not set permissions to Realm folder: \(error).")
            }
        }
    }
}

public extension CacheRealmStore {
    
    var lastPulledAt: Date? {
        return getSyncActivity(for: SeedPayload.self)?.lastPulledAt
    }
    
    func createOrUpdate(with request: DataStoreModels.CacheRequest, completion: @escaping (Result<SeedPayloadType, DataError>) -> Void) {
        // Ensure there is data before proceeding
        guard !request.payload.isEmpty else {
            Log(debug: "No modified data to cache.")
            DispatchQueue.main.async { completion(.success(request.payload)) }
            return
        }
        
        // Write source data to local storage
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.cacheFailure(error))) }
                return
            }
            
            // Transform data
            let post = request.payload.posts.map { PostRealmObject(from: $0) }
            let media = request.payload.media.map { MediaRealmObject(from: $0) }
            let authors = request.payload.authors.map { AuthorRealmObject(from: $0) }
            let terms = request.payload.terms.map { TermRealmObject(from: $0) }
            
            do {
                try realm.write {
                    realm.add(post, update: true)
                    realm.add(media, update: true)
                    realm.add(authors, update: true)
                    realm.add(terms, update: true)
                }
                
                // Persist sync date for next use if applicable
                try self.updateSyncActivity(
                    for: SeedPayload.self,
                    lastPulledAt: request.lastPulledAt,
                    with: realm
                )
                
                self.Log(debug: "Cache modified data complete for "
                    + "\(post.count) posts, \(media.count) media, \(authors.count) authors, and \(terms.count) terms.")
                
                DispatchQueue.main.async { completion(.success(request.payload)) }
                return
            } catch {
                self.Log(error: "Could not write modified data to Realm from the source: \(error)")
                DispatchQueue.main.async { completion(.failure(.cacheFailure(error))) }
                return
            }
        }
    }
}

public extension CacheRealmStore {
    
    func delete(for userID: Int) {
        DispatchQueue.database.sync {
            _delete(for: userID)
        }
    }
    
    /// Delete without thread.
    private func _delete(for userID: Int) {
        guard let directory = folderURL?.path else { return }
        
        do {
            let filenames = try FileManager.default.contentsOfDirectory(atPath: directory)
            let currentName = generateName(for: userID)
            
            try filenames
                .filter { $0.hasPrefix("\(currentName).") }
                .forEach { filename in
                    try FileManager.default.removeItem(atPath: "\(directory)/\(filename)")
            }
            
            Log(warn: "Deleted Realm database at: \(directory)/\(currentName).realm")
        } catch {
            Log(error: "Could not delete user's database: \(error)")
        }
    }
}

// MARK: - Helpers

private extension CacheRealmStore {
    
    /// Get sync activity for type.
    func getSyncActivity<T>(for type: T.Type) -> SyncActivity? {
        let realm: Realm
        let typeName = String(describing: type)
        
        do {
            realm = try Realm()
        } catch {
            Log(error: "Could not initialize database: \(error)")
            return nil
        }
        
        return realm.object(ofType: SyncActivity.self, forPrimaryKey: typeName)
    }
    
    /// Update or create last pulled at date for sync activity.
    func updateSyncActivity<T>(for type: T.Type, lastPulledAt: Date, with realm: Realm) throws {
        let typeName = String(describing: type)
        
        try realm.write {
            realm.create(SyncActivity.self, value: [
                "type": typeName,
                "lastPulledAt": lastPulledAt
            ], update: true)
        }
    }
}
