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
}

extension RealmControllable {

    var sortProperty: String {
        return "date"
    }

    var sortAscending: Bool {
        return false
    }
    
    func setupDataSource() {
        models = AppGlobal.realm?.objects(DataType.self).sorted(
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
    
    func applyFilterAndSort(_ filter: String? = nil, sort: String? = nil, ascending: Bool? = nil, reload: Bool = true) {
        guard let realm = AppGlobal.realm else { return }
        
        var temp = realm.objects(DataType.self)
            .sorted(byKeyPath: sortProperty, ascending: ascending ?? sortAscending)
        
        if let filter = filter, !filter.isEmpty {
            temp = temp.filter(filter)
        }
        
        if let sort = sort, !sort.isEmpty {
            temp = temp.sorted(byKeyPath: sort, ascending: ascending ?? sortAscending)
        }

        models = temp
        
        if reload {
            dataView.reloadData()
        }
        
        dataView.scrollToTop()
    }
}
