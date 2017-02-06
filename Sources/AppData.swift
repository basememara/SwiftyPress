//
//  AppData.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2/6/17.
//
//

import Foundation
import RealmSwift

struct AppData {

    init() {
        let fileManager = FileManager.default
        
        // Remove previous database to allow fresh data and schema to be recreated
        if let defaultURL = Realm.Configuration.defaultConfiguration.fileURL, fileManager.fileExists(atPath: defaultURL.path) {
            // Handle database auxiliary files
            let folderPath = defaultURL.deletingLastPathComponent().path
            do {
                try fileManager.contentsOfDirectory(atPath: folderPath)
                    .filter { $0.hasPrefix(defaultURL.lastPathComponent) }
                    .forEach { try fileManager.removeItem(atPath: "\(folderPath)/\($0)") }
            } catch {
                Log(error: "Could not remove Realm auxiliary files: \(error).")
            }
        }
        
        // Create default location of Realm
        guard let folderURL = fileManager
            .urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Realm")
                else { return }
        
        // Set the configuration used for the default Realm
        let realmFileURL = folderURL.appendingPathComponent("default.realm")
        Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: realmFileURL)
        
        // Create default location and set permissions
        guard !fileManager.fileExists(atPath: folderURL.path) else { return }
        do {
            // Create directory if does not exist yet
            try fileManager.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            
            // Decrease file protection after first open for the parent directory
            try fileManager.setAttributes([
                FileAttributeKey.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication
            ], ofItemAtPath: folderURL.path)
        } catch {
            Log(error: "Could not set permissions to Realm folder: \(error).")
        }
        
        // Seed data to fresh database
        guard let seedFileURL = Bundle.main.url(forResource: "seed", withExtension: "realm", subdirectory: "\(AppGlobal.userDefaults[.baseDirectory])/data"),
            fileManager.fileExists(atPath: seedFileURL.path) else {
                // Construct from a series of REST requests
                PostService().seedFromRemote()
                Log(warn: "Could not find seed database file.")
                return
            }
        
        // Use pre-created seed database
        do { try fileManager.copyItem(at: seedFileURL, to: realmFileURL) }
        catch { Log(error: "Could not seed database from file: \(error).") }
    }
}
