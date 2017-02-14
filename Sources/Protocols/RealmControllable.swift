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
    
    var notificationToken: NotificationToken? { get set }
    var service: ServiceType { get }
    var models: Results<DataType>? { get set }
    var filter: String? { get }
    var sortProperty: String { get }
    var sortAscending: Bool { get }
}

extension RealmControllable {

    var filter: String? {
        return nil
    }
    
    var sortProperty: String {
        return "date"
    }

    var sortAscending: Bool {
        return false
    }
    
    func setupDataSource() {
        guard let realm = try? Realm() else { return }
        var temp = realm.objects(DataType.self)
        
        if let filter = filter, !filter.isEmpty {
            temp = temp.filter(filter)
        }
        
        models = temp.sorted(
            byKeyPath: sortProperty, ascending: sortAscending)
        
        // Set results notification block
        notificationToken = models?.addNotificationBlock { [unowned self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial, .update:
                self.dataView.reloadData()
            case .error(let err):
                // An error occurred while opening the Realm file
                // on the background worker thread
                fatalError("\(err)")
            }
        }
        
        dataView.reloadData()
    }
    
    func applyFilterAndSort(predicate: NSPredicate?, sort: String? = nil, ascending: Bool? = nil, reload: Bool = true) {
        guard let realm = try? Realm() else { return }
        
        var temp = realm.objects(DataType.self)
        
        if let predicate = predicate {
            temp = temp.filter(predicate)
        }

        models = temp.sorted(byKeyPath: sort ?? sortProperty, ascending: ascending ?? sortAscending)
        
        if reload {
            dataView.reloadData()
        }
        
        dataView.scrollToTop()
    }
    
    func applyFilterAndSort(_ filter: String? = nil, sort: String? = nil, ascending: Bool? = nil, reload: Bool = true) {
        var predicate: NSPredicate? = nil
        
        if let filter = (filter ?? self.filter), !filter.isEmpty {
            predicate = NSPredicate(format: filter)
        }
        
        applyFilterAndSort(predicate: predicate, sort: sort, ascending: ascending, reload: reload)
    }
}
