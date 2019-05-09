//
//  LogDNADestination.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-17.
//

import SwiftyBeaver
#if canImport(UIKit)
import UIKit
#endif

class LogDNADestination: BaseDestination, HasDependencies {
    private static var payload = [[String: Any]]()
    
    private let ingestionKey: String
    private let hostName: String
    private let appName: String
    private let environment: String
    
    private var ingestURL: String {
        return "https://logs.logdna.com/logs/ingest?hostname=\(hostName)&now=\(Date().timeIntervalSince1970)"
    }
    
    private lazy var deviceIdentifier: String = {
        #if os(iOS)
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
        #else
        return ""
        #endif
    }()
    
    private lazy var httpService: HTTPServiceType = dependencies.resolveService()
    
    override var defaultHashValue: Int {
        return "\(LogDNADestination.self)".hashValue
    }
    
    init(ingestionKey: String, hostName: String, appName: String, environment: String) {
        self.ingestionKey = ingestionKey
        self.hostName = hostName
        self.appName = appName
        self.environment = environment
        
        super.init()
    }
    
    override public func send(_ level: SwiftyBeaver.Level, msg: String, thread: String, file: String, function: String, line: Int, context: Any? = nil) -> String? {
        let parameters: [String: Any] = [
            "line": msg,
            "level": {
                switch level {
                case .debug, .verbose: return "DEBUG"
                case .info: return "INFO"
                case .warning: return "WARN"
                case .error: return "ERROR"
                }
            }(),
            "timestamp": Date().timeIntervalSince1970,
            "app": appName,
            "env": environment,
            "meta": {
                var codeMeta: [String: Any] = [
                    "device_id": deviceIdentifier,
                    "code": [
                        "fileName": file.components(separatedBy: "/").last ?? "",
                        "function": function,
                        "line": line
                    ]
                ]
                
                if let context = context as? [String: Any] {
                    codeMeta.merge(context) { old, new in old }
                }
                
                return codeMeta
            }()
        ]
        
        // Append to payload queue
        LogDNADestination.payload.append(parameters)
        
        // Send immediately
        flush()
        
        return parameters.jsonString
    }
    
    func flush() {
        // Construct authorization
        guard let credentialData = "\(ingestionKey):\(ingestionKey)".data(using: .utf8) else { return }
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = [
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "Basic \(base64Credentials)"
        ]
        
        // Construct parameters and handle queue
        let payload = LogDNADestination.payload
        LogDNADestination.payload.removeAll()
        let parameters: [String: Any] = ["lines": payload]
        
        // Send remotely
        httpService.post(url: ingestURL, parameters: parameters, headers: headers) {
            guard case .failure = $0 else { return }
            LogDNADestination.payload += payload //Failed so try next time
        }
    }
}
