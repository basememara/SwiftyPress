//
//  ThemeService.swift
//  SwiftyPress iOS
//
//  Created by Basem Emara on 2018-09-23.
//

import UIKit

public class ThemeWorker: ThemeWorkerType {
    private let store: ThemeStore
    
    public init(store: ThemeStore) {
        self.store = store
    }
}

public extension ThemeWorker {
    
    func apply(for application: UIApplication) {
        store.apply(for: application)
    }
}
