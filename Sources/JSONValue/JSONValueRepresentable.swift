//
//  JSONValueRepresentable.swift
//  Created by Shawn Throop on 29.08.20.
//

import Foundation

/// A value that can be losslessly converted to and from JSON.
public protocol JSONValueRepresentable {
    
    /// Creates an instance of the reciever from the given value.
    init?(json: JSONValue)
    
    /// Provides a JSONValue representation of the reciever.
    func asJSON() -> JSONValue
}



extension Optional: JSONValueRepresentable where Wrapped: JSONValueRepresentable {

    public init?(json: JSONValue) {
        self = json == .null ? .none : Wrapped(json: json)
    }

    public func asJSON() -> JSONValue {
        switch self {
        case .some(let wrapped):
            return wrapped.asJSON()
        case .none:
            return .null
        }
    }
}


extension Bool: JSONValueRepresentable {

    public init?(json: JSONValue) {
        switch json {
        case .bool(let value):
            self = value
        default:
            return nil
        }
    }

    public func asJSON() -> JSONValue { .bool(self) }
}


extension Int: JSONValueRepresentable {

    public init?(json: JSONValue) {
        switch json {
        case .int(let value):
            self = value
        default:
            return nil
        }
    }

    public func asJSON() -> JSONValue { .int(self) }
}


extension Double: JSONValueRepresentable {
        
    public init?(json: JSONValue) {
        switch json {
        case .double(let value):
            self = value
        default:
            return nil
        }
    }

    public func asJSON() -> JSONValue { .double(self) }
}


extension String: JSONValueRepresentable {

    public init?(json: JSONValue) {
        switch json {
        case .string(let value):
            self = value
        default:
            return nil
        }
    }

    public func asJSON() -> JSONValue { .string(self) }
}
