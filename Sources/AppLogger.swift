//
//  AppLogger.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2/6/17.
//
//

import Foundation
import SwiftyBeaver

private let log = SwiftyBeaver.self

func setupLogger() {
    log.addDestination(ConsoleDestination())
    
    // File output configurations
    var logFileURL: URL?
    log.addDestination({
        $0.logFileURL = $0.logFileURL?
            .deletingLastPathComponent()
            .appendingPathComponent("swiftypress.log")
        logFileURL = $0.logFileURL
        return $0
    }(FileDestination()))
    
    // Handle file protection for logging to occur in various app states
    if let url = logFileURL {
        _ = try? FileManager.default.setAttributes([
            FileAttributeKey.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication
        ], ofItemAtPath: url.absoluteString)
    }
    
    // Touch log file for setting attributes later
    Log(info: "Logger initialized")
}

/**
 Log something generally unimportant (lowest priority; not written to file)

 - parameter message: Description of the log.
 - parameter includeMeta: If true, will append the meta data to the log.
 - parameter path: Path of the caller.
 - parameter function: Function of the caller.
 - parameter line: Line of the caller.
 */
public func Log(verbose message: String, includeMeta: Bool = true, path: String = #file, function: String = #function, line: Int = #line) {
    log.verbose(message + metaLog, path, function, line: line)
}

/**
 Log something which help during debugging (low priority; not written to file)

 - parameter message: Description of the log.
 - parameter includeMeta: If true, will append the meta data to the log.
 - parameter path: Path of the caller.
 - parameter function: Function of the caller.
 - parameter line: Line of the caller.
 */
public func Log(debug message: String, includeMeta: Bool = true, path: String = #file, function: String = #function, line: Int = #line) {
    log.debug(message + metaLog, path, function, line: line)
}

/**
 Log something which you are really interested but which is not an issue or error (normal priority)

 - parameter message: Description of the log.
 - parameter includeMeta: If true, will append the meta data to the log.
 - parameter path: Path of the caller.
 - parameter function: Function of the caller.
 - parameter line: Line of the caller.
 */
public func Log(info message: String, includeMeta: Bool = true, path: String = #file, function: String = #function, line: Int = #line) {
    log.info(message + metaLog, path, function, line: line)
}

/**
 Log something which may cause big trouble soon (high priority)

 - parameter message: Description of the log.
 - parameter includeMeta: If true, will append the meta data to the log.
 - parameter path: Path of the caller.
 - parameter function: Function of the caller.
 - parameter line: Line of the caller.
 */
public func Log(warn message: String, includeMeta: Bool = true, path: String = #file, function: String = #function, line: Int = #line) {
    log.warning(message + metaLog, path, function, line: line)
}

/**
 Log something which will keep you awake at night (highest priority)

 - parameter message: Description of the log.
 - parameter includeMeta: If true, will append the meta data to the log.
 - parameter path: Path of the caller.
 - parameter function: Function of the caller.
 - parameter line: Line of the caller.
 */
public func Log(error message: String, includeMeta: Bool = true, path: String = #file, function: String = #function, line: Int = #line) {
    log.error(message + metaLog, path, function, line: line)
}

/// Meta data to append to the log
private var metaLog: String {
    var applicationState = ""
    switch UIApplication.shared.applicationState {
    case .active: applicationState = "Active"
    case .background: applicationState = "Background"
    case .inactive: applicationState = "Inactive"
    }

    return "\n["
        + "Application state: \(applicationState), "
        + "Protected data available: \(UIApplication.shared.isProtectedDataAvailable)"
        + "]\n"
}
