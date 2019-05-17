//
//  ApplicationTest.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-05-17.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamKit
import SwiftyPress

/// Principle class run before any tests begin, see Info.plist
class TestApplication: NSObject, CoreInjection, HasDependencies {
    private lazy var preferences: PreferencesType = dependencies.resolve()
    private lazy var dataWorker: DataWorkerType = dependencies.resolve()
    
    override init() {
        super.init()
        
        // Setup dependency injection
        inject(dependencies: TestConfigurator())
        
        // Setup database
        dataWorker.resetCache(for: preferences.userID ?? 0)
        dataWorker.configure()
    }
}
