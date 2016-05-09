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
            // TODO: Log error
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
        
        if realm?.objects(DataType).count == 0 {
            service.seedFromDisk()
        }
    }
    
    func applyFilterAndSort(filter filter: String? = nil, sort: String? = nil, ascending: Bool? = nil) {
        guard let realm = realm else { return }
        
        var temp = realm.objects(DataType.self)
            .sorted(sortProperty, ascending: ascending ?? sortAscending)
        
        if let filter = filter where !filter.isEmpty {
            temp = temp.filter(filter)
        }
        
        if let sort = sort where !sort.isEmpty {
            temp = temp.sorted(sort, ascending: ascending ?? sortAscending)
        }

        models = temp
        
        dataView.reloadData()
        dataView.scrollToTop()
    }
}