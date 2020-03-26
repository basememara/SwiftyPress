//
//  Taxonomy.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-02.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

public enum Taxonomy: Decodable {
    case category
    case tag
    case other(String)
}

// MARK: - Codable

extension Taxonomy {
    
    private enum CodingKeys: String, CodingKey {
        case category
        case tag = "post_tag"
        case other
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = .init(rawValue: try container.decode(String.self))
    }
}


// MARK: - Helpers

public extension Taxonomy {
    
    var rawValue: String {
        switch self {
        case .category:
            return CodingKeys.category.rawValue
        case .tag:
            return CodingKeys.tag.rawValue
        case .other(let value):
            return value
        }
    }
    
    init(rawValue: String) {
        switch rawValue {
        case CodingKeys.category.rawValue:
            self = .category
        case CodingKeys.tag.rawValue:
            self = .tag
        default:
            self = .other(rawValue)
        }
    }
}

public extension Taxonomy {
    
    var localized: String {
        switch self {
        case .category:
            return .localized(.categorySection)
        case .tag:
            return .localized(.tagSection)
        case .other(let value):
            return .localized(.taxonomy(for: value))
        }
    }
}

extension Taxonomy: Equatable {
    
    public static func == (lhs: Taxonomy, rhs: Taxonomy) -> Bool {
        switch (lhs, rhs) {
        case (.category, .category):
            return true
        case (.tag, .tag):
            return true
        case (let .other(lhsValue), let .other(rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}

extension Taxonomy: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
