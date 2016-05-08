//
//  RealmControllable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/8/16.
//
//

import UIKit
import ZamzamKit
import RealmSwift

protocol RealmControllable: DataControllable {
    associatedtype ServiceType: Serviceable
    associatedtype DataType: Object
    
    var realm: Realm? { get set }
    var notificationToken: NotificationToken? { get set }
    var service: ServiceType { get }
    var models: Results<DataType>? { get set }
}

extension RealmControllable {

    var sortProperty: String {
        return "date"
    }

    var sortAscending: Bool {
        return false
    }
    
    func setupDataSource() {
        do {
            realm = try Realm()
        } catch {
            // Log error
        }
        
        models = realm?.objects(DataType).sorted(
            sortProperty, ascending: sortAscending)
        
        // Set results notification block
        notificationToken = models?.addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .Initial, .Update:
                self.dataView.reloadData()
            case .Error(let err):
                // An error occurred while opening the Realm file
                // on the background worker thread
                fatalError("\(err)")
            }
        }
        
        service.seedFromDisk()
    }
}