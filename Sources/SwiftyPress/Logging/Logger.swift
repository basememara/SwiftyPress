//
//  Logger.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyBeaver
import ZamzamCore
import ZamzamUI

fileprivate final class Logger: AppInfo {
    static let shared = Logger()
    
    @Inject private var module: SwiftyPressModule
    private lazy var constants: ConstantsType = module.component()
    
    fileprivate lazy var minLogLevel: SwiftyBeaver.Level = constants
        .environment == .production ? .info : .verbose
    
    fileprivate var logFileURL: URL?
    
    private let systemVersion: String = {
        #if os(iOS)
        return "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        #else
        return ""
        #endif
    }()
    
    private lazy var version: String = "\(appVersion ?? "-") (\(appBuild ?? "-"))"
    
    private lazy var deviceModel: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }()
    
    let log = SwiftyBeaver.self
    
    private init() {
        // Setup up console logging
        log.addDestination(
            ConsoleDestination().with {
                $0.format = "$DHH:mm:ss$d $C$L$c $N.$F:$l - $M"
            }
        )
        
        setupLocal()
        setupCloud()
    }
}

private extension Logger {
    
    func setupLocal() {
        // File output configurations
        log.addDestination(
            FileDestination().with {
                $0.logFileURL = $0.logFileURL?
                    .deletingLastPathComponent()
                    .appendingPathComponent("\(constants.logFileName).dev")
                
                $0.format = "$Dyyyy-MM-dd HH:mm:ssZ$d $C$L$c $N.$F:$l - $M\nMeta: $X"
                $0.minLevel = minLogLevel
                
                // Save log file location for later use
                logFileURL = $0.logFileURL
            }
        )
        
        // Handle file protection so logging can occur in the locked background state
        #if !os(OSX)
        if let url = logFileURL {
            _ = try? FileManager.default.setAttributes(
                [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication],
                ofItemAtPath: url.absoluteString
            )
        }
        #endif
        
        // Touch log file for setting security attributes
        log.info("Log file initialized")
        log.debug("Log file location: \(String(describing: logFileURL))")
    }
    
    func setupCloud() {
        // TODO: Log injection, Bugfender, LogDNA, Crashlytics, etc
    }
}

extension Logger {
    
    /// Meta data to append to the log
    var metaLog: [String: Any] {
        var output: [String: Any] = [
            "app_version": version,
            "system_version": systemVersion,
            "device_model": deviceModel,
            "environment": constants.environment.rawValue
        ]
        
        #if os(iOS)
        if let application = Logger.application {
            output["application_state"] = {
                switch application.applicationState {
                case .active:
                    return "active"
                case .background:
                    return "background"
                case .inactive:
                    return "inactive"
                @unknown default:
                    return "unknown"
                }
            }()
            
            output["protected_data_available"] = application.isProtectedDataAvailable
        }
        #elseif os(watchOS)
        if let application = Logger.application {
            output["application_state"] = {
                switch application.applicationState {
                case .active:
                    return "active"
                case .background:
                    return "background"
                case .inactive:
                    return "inactive"
                @unknown default:
                    return "unknown"
                }
            }()
            
            output["is_running_in_dock"] = application.isApplicationRunningInDock
        }
        #endif
        
        return output
    }
}

public extension Loggable {
    
    /**
     Log something generally unimportant (lowest priority; not written to file)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func Log(verbose message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard SwiftyBeaver.Level.verbose.rawValue >= Logger.shared.minLogLevel.rawValue else { return }
        
        DispatchQueue.main.async {
            Logger.shared.log.verbose(message, path, function, line: line, context: Logger.shared.metaLog)
            
            Logger.injectedShared?.forEach {
                $0.Log(verbose: message, path: path, function: function, line: line, context: Logger.shared.metaLog)
            }
        }
    }
    
    /**
     Log something which help during debugging (low priority; not written to file)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func Log(debug message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard SwiftyBeaver.Level.debug.rawValue >= Logger.shared.minLogLevel.rawValue else { return }
        
        DispatchQueue.main.async {
            Logger.shared.log.debug(message, path, function, line: line, context: Logger.shared.metaLog)
            
            Logger.injectedShared?.forEach {
                $0.Log(debug: message, path: path, function: function, line: line, context: Logger.shared.metaLog)
            }
        }
    }
    
    /**
     Log something which you are really interested but which is not an issue or error (normal priority)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func Log(info message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard SwiftyBeaver.Level.info.rawValue >= Logger.shared.minLogLevel.rawValue else { return }
        
        DispatchQueue.main.async {
            Logger.shared.log.info(message, path, function, line: line, context: Logger.shared.metaLog)
            
            Logger.injectedShared?.forEach {
                $0.Log(info: message, path: path, function: function, line: line, context: Logger.shared.metaLog)
            }
        }
    }
    
    /**
     Log something which may cause big trouble soon (high priority)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func Log(warn message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard SwiftyBeaver.Level.warning.rawValue >= Logger.shared.minLogLevel.rawValue else { return }
        
        DispatchQueue.main.async {
            Logger.shared.log.warning(message, path, function, line: line, context: Logger.shared.metaLog)
            
            Logger.injectedShared?.forEach {
                $0.Log(warn: message, path: path, function: function, line: line, context: Logger.shared.metaLog)
            }
        }
    }
    
    /**
     Log something which will keep you awake at night (highest priority)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func Log(error message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard SwiftyBeaver.Level.error.rawValue >= Logger.shared.minLogLevel.rawValue else { return }
        
        DispatchQueue.main.async {
            Logger.shared.log.error(message, path, function, line: line, context: Logger.shared.metaLog)
            
            Logger.injectedShared?.forEach {
                $0.Log(error: message, path: path, function: function, line: line, context: Logger.shared.metaLog)
            }
        }
    }
}

// MARK: - Network logging helpers

public extension Loggable {
    
    /**
     Log URL request which help during debugging (low priority; not written to file)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func Log(request: URLRequest?, path: String = #file, function: String = #function, line: Int = #line) {
        guard SwiftyBeaver.Level.debug.rawValue >= Logger.shared.minLogLevel.rawValue else { return }
        
        let message: String = {
            var output = "Request: {\n"
            guard let request = request else { return "Request: empty" }
            
            if let value = request.url?.absoluteString {
                output += "\turl: \(value),\n"
            }
            
            if let value = request.httpMethod {
                output += "\tmethod: \(value),\n"
            }
            
            if let value = request.allHTTPHeaderFields?.scrubbed {
                output += "\theaders: \(value)\n"
            }
            
            output += "}"
            return output
        }()
        
        DispatchQueue.main.async {
            self.Log(debug: message, path: path, function: function, line: line, context: Logger.shared.metaLog)
            
            Logger.injectedShared?.forEach {
                $0.Log(debug: message, path: path, function: function, line: line, context: Logger.shared.metaLog)
            }
        }
    }
    
    /**
     Log HTTP response which help during debugging (low priority; not written to file)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func Log(response: NetworkAPI.Response?, url: String?, path: String = #file, function: String = #function, line: Int = #line) {
        guard SwiftyBeaver.Level.debug.rawValue >= Logger.shared.minLogLevel.rawValue else { return }
        
        let message: String = {
            var message = "Response: {\n"
            
            if let value = url {
                message += "\turl: \(value),\n"
            }
            
            if let response = response {
                message += "\tstatus: \(response.statusCode),\n"
                message += "\theaders: \(response.headers.scrubbed)\n"
            }
            
            message += "}"
            return message
        }()
        
        DispatchQueue.main.async {
            self.Log(debug: message, path: path, function: function, line: line, context: Logger.shared.metaLog)
            
            Logger.injectedShared?.forEach {
                $0.Log(debug: message, path: path, function: function, line: line, context: Logger.shared.metaLog)
            }
        }
    }
}

// MARK: - Expose injectable logger

extension Logger {
    fileprivate static var injectedShared: [Loggable]?
}

public extension Loggable {
    
    /// Set up injected loggers for consumers to plugin
    func inject(loggers: [Loggable]) {
        Logger.injectedShared = loggers
    }
}

// MARK: - Allow application state to be logged

#if os(iOS)
import UIKit

extension Logger {
    fileprivate static var application: UIApplication?
}

public extension Loggable where Self: ApplicationPlugin {
    
    /// Configure logger with current application for state logging
    func setupLogger(for application: UIApplication, inject loggers: [Loggable]? = nil) {
        Logger.application = application
        
        if let loggers = loggers {
            self.inject(loggers: loggers)
        }
    }
}
#elseif os(watchOS)
import WatchKit

extension Logger {
    fileprivate static var application: WKExtension?
}

public extension Loggable where Self: ExtensionModule {
    
    /// Configure logger with current application for state logging
    func setupLogger(for application: WKExtension, inject loggers: [Loggable]? = nil) {
        Logger.application = application
        
        if let loggers = loggers {
            self.inject(loggers: loggers)
        }
    }
}
#endif

// MARK: - Helpers

extension BaseDestination: With {}

public extension ConstantsType {
    var logFileURL: URL? { Logger.shared.logFileURL }
}
