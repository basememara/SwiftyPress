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
        
        if models?.count ?? 0 == 0 {
            service.seedFromDisk()
        } else {
            dataView.reloadData()
        }
        
        service.updateFromRemote()
    }
    
    func applyFilterAndSort(filter filter: String? = nil, sort: String? = nil, ascending: Bool? = nil, reload: Bool = true) {
        guard let realm = AppGlobal.realm else { return }
        
        var temp = realm.objects(DataType.self)
            .sorted(sortProperty, ascending: ascending ?? sortAscending)
        
        if let filter = filter where !filter.isEmpty {
            temp = temp.filter(filter)
        }
        
        if let sort = sort where !sort.isEmpty {
            temp = temp.sorted(sort, ascending: ascending ?? sortAscending)
        }

        models = temp
        
        if reload {
            dataView.reloadData()
        }
        
        dataView.scrollToTop()
    }
}