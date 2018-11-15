//
//  HasDependencies.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

/// Attach to any type for exposing the dependency factory.
public protocol HasDependencies { }
public extension HasDependencies {
    
    /// Container for dependency instance factories
    var dependencies: DependencyFactoryType {
        return DependencyInjector.dependencies
    }
}

/// Attach to any type for reassign the dependency factory to another instance.
/// Usually happens very early in the application or test lifecycle.
public protocol DependencyConfigurator { }
public extension DependencyConfigurator {
    
    /// Declare dependency container to use
    func register(dependencies: DependencyFactoryType) {
        DependencyInjector.dependencies = dependencies
    }
}

// Statically store dependency factory in memory.
fileprivate struct DependencyInjector {
    static var dependencies: DependencyFactoryType = DependencyFactory()
}
