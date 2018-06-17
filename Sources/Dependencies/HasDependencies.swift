//
//  HasDependencies.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

/// Attach to any type for exposing the dependency container
public protocol HasDependencies {
    var dependencies: Dependable { get }
}

public extension HasDependencies {
    
    /// Container for dependency instance factories
    var dependencies: Dependable {
        return DependencyInjector.dependencies
    }
}

/// Used to pass around dependency container
/// which can be reassigned to another container
private struct DependencyInjector {
    static var dependencies: Dependable = Dependency()
}

public protocol DependencyConfigurator { }
public extension DependencyConfigurator {
    
    /// Declare dependency container to use
    func register(dependencies: Dependable) {
        DependencyInjector.dependencies = dependencies
    }
}
