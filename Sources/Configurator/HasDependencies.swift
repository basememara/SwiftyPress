//
//  HasDependencies.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//
//  http://basememara.com/swift-protocol-oriented-dependency-injection/
//

/// The `dependencies` property is provided as a factory for creating instances.
public protocol HasDependencies {}
public extension HasDependencies {
    
    /// Container for core dependency instance factories
    var dependencies: CoreDependable {
        return InjectionStorage.dependencies
    }
}

/// Adopters can assign a dependency factory to use for instances.
///
///     class MyModule: CoreInjection {
///
///         init() {
///             inject(dependencies: AppConfigurator())
///         }
///     }
///
///     class AppConfigurator: CoreConfigurator {
///
///         override func resolve() -> ConstantsType {
///             return Constants(...)
///         }
///     }
///
/// The `inject` method should occur early in the application or test lifecycle.
public protocol CoreInjection {}
public extension CoreInjection {
    
    /// Declare core dependency container to use
    static func inject(dependencies: CoreDependable) {
        InjectionStorage.dependencies = dependencies
    }
    
    /// Declare core dependency container to use
    func inject(dependencies: CoreDependable) {
        InjectionStorage.dependencies = dependencies
    }
}

// Statically store the dependency factory in memory.
private struct InjectionStorage {
    static var dependencies: CoreDependable = CoreConfigurator()
}
