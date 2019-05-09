//
//  Logger.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-17.
//

import SwiftyBeaver
import ZamzamKit

fileprivate final class Logger: AppInfo, HasDependencies {
    static var shared = Logger()
    
    private lazy var constants: ConstantsType = dependencies.resolve()
    
    let systemVersion: String = {
        #if os(iOS)
        return "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        #else
        return ""
        #endif
    }()
    
    lazy var version: String = "\(appVersion ?? "-") (\(appBuild ?? "-"))"
    
    lazy var deviceModel: String = {
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
        var logFileURL: URL?
        
        // File output configurations
        log.addDestination(
            FileDestination().with {
                $0.logFileURL = $0.logFileURL?
                    .deletingLastPathComponent()
                    .appendingPathComponent("\(constants.logFileName).dev")
                
                $0.format = "$Dyyyy-MM-dd HH:mm:ssZ$d $C$L$c $N.$F:$l - $M\nMeta: $X"
                $0.minLevel = constants.environment == .production ? .info : .verbose
                
                // Save log file location for later use
                logFileURL = $0.logFileURL
            }
        )
        
        // Handle file protection so logging can occur in the locked background state
        if let url = logFileURL {
            _ = try? FileManager.default.setAttributes(
                [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication],
                ofItemAtPath: url.absoluteString
            )
        }
        
        // Touch log file for setting security attributes
        log.info("Log file initialized")
        log.debug("Log file location: \(String(describing: logFileURL))")
    }
    
    func setupCloud() {
        guard let logDNAKey = constants.logDNAKey else { return }
        
        // Setup LogDNA if applicable
        log.addDestination(
            LogDNADestination(
                ingestionKey: logDNAKey,
                hostName: "iOS",
                appName: appDisplayName ?? "",
                environment: isInTestFlight ? "TestFlight" : constants.environment.rawValue.capitalized
            ).with {
                $0.minLevel = .info
            }
        )
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
    func Log(verbose message: String, path: String = #file, function: String = #function, line: Int = #line) {
        DispatchQueue.main.async {
            Logger.shared.log.verbose(message, path, function, line: line, context: Logger.shared.metaLog)
            Logger.injectedShared?.Log(verbose: message, path: path, function: function, line: line)
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
    func Log(debug message: String, path: String = #file, function: String = #function, line: Int = #line) {
        DispatchQueue.main.async {
            Logger.shared.log.debug(message, path, function, line: line, context: Logger.shared.metaLog)
            Logger.injectedShared?.Log(debug: message, path: path, function: function, line: line)
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
    func Log(info message: String, path: String = #file, function: String = #function, line: Int = #line) {
        DispatchQueue.main.async {
            Logger.shared.log.info(message, path, function, line: line, context: Logger.shared.metaLog)
            Logger.injectedShared?.Log(info: message, path: path, function: function, line: line)
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
    func Log(warn message: String, path: String = #file, function: String = #function, line: Int = #line) {
        DispatchQueue.main.async {
            Logger.shared.log.warning(message, path, function, line: line, context: Logger.shared.metaLog)
            Logger.injectedShared?.Log(warn: message, path: path, function: function, line: line)
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
    func Log(error message: String, path: String = #file, function: String = #function, line: Int = #line) {
        DispatchQueue.main.async {
            Logger.shared.log.error(message, path, function, line: line, context: Logger.shared.metaLog)
            Logger.injectedShared?.Log(error: message, path: path, function: function, line: line)
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
        Log(
            debug: {
                var message = "Request: {\n"
                guard let request = request else { return "Request: empty" }
                
                if let value = request.url?.absoluteString {
                    message += "\turl: \(value),\n"
                }
                
                if let value = request.httpMethod {
                    message += "\tmethod: \(value),\n"
                }
                
                if let value = request.allHTTPHeaderFields?.scrubbed {
                    message += "\theaders: \(value)\n"
                }
                
                message += "}"
                return message
            }(),
            path: path,
            function: function,
            line: line
        )
    }
    
    /**
     Log HTTP response which help during debugging (low priority; not written to file)
     
     - parameter message: Description of the log.
     - parameter includeMeta: If true, will append the meta data to the log.
     - parameter path: Path of the caller.
     - parameter function: Function of the caller.
     - parameter line: Line of the caller.
     */
    func Log(response: ServerResponse?, url: String?, path: String = #file, function: String = #function, line: Int = #line) {
        Log(
            debug: {
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
            }(),
            path: path,
            function: function,
            line: line
        )
    }
}

// MARK: - Expose injectable logger

extension Logger {
    fileprivate static var injectedShared: Loggable?
}

public extension Loggable {
    
    /// Set up injected logger for consumers to plugin
    func inject(logger: Loggable) {
        Logger.injectedShared = logger
    }
}

// MARK: - Allow application state to be logged

#if os(iOS)
import UIKit

extension Logger {
    fileprivate static var application: UIApplication?
}

public extension Loggable where Self: ApplicationModule {
    
    /// Configure logger with current application for state logging
    func setupLogger(for application: UIApplication, inject logger: Loggable? = nil) {
        Logger.application = application
        
        if let logger = logger {
            self.inject(logger: logger)
        }
    }
}
#endif

// MARK: - Helpers

extension BaseDestination: With {}
