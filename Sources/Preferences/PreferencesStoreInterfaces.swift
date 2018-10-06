//
//  PreferencesStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-06.
//

import ZamzamKit

public protocol PreferencesStore {
    func get<T>(_ key: DefaultsKey<T?>) -> T?
    func set<T>(_ value: T?, forKey key: DefaultsKey<T?>)
    func remove<T>(_ key: DefaultsKey<T?>)
}

public protocol PreferencesType: PreferencesStore {
    func clear()
}
