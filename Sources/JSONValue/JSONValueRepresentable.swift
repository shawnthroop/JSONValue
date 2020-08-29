//
//  JSONValueRepresentable.swift
//  Created by Shawn Throop on 29.08.20.
//

/// A value interchangeable with `JSONValue`.
public protocol JSONValueRepresentable {
    
    var jsonValue: JSONValue { get }
    
    init?(json: JSONValue)
}



extension Bool: JSONValueRepresentable {
    
    public var jsonValue: JSONValue { .bool(self) }
    
    public init?(json: JSONValue) {
        switch json {
        case .bool(let value):
            self = value
        default:
            return nil
        }
    }
}


extension Int: JSONValueRepresentable {
    
    public var jsonValue: JSONValue { .int(self) }
    
    public init?(json: JSONValue) {
        switch json {
        case .int(let value):
            self = value
        default:
            return nil
        }
    }
}


extension Double: JSONValueRepresentable {
    
    public var jsonValue: JSONValue { .double(self) }
    
    public init?(json: JSONValue) {
        switch json {
        case .double(let value):
            self = value
        default:
            return nil
        }
    }
}


extension String: JSONValueRepresentable {
    
    public var jsonValue: JSONValue { .string(self) }
    
    public init?(json: JSONValue) {
        switch json {
        case .string(let value):
            self = value
        default:
            return nil
        }
    }
}


extension JSONObject: JSONValueRepresentable {
    
    public var jsonValue: JSONValue { .object(self) }
    
    public init?(json: JSONValue) {
        switch json {
        case .object(let objectValue):
            self = objectValue
        default:
            return nil
        }
    }
}


extension JSONArray: JSONValueRepresentable {
    
    public var jsonValue: JSONValue { .array(self) }
    
    public init?(json: JSONValue) {
        switch json {
        case .array(let arrayValue):
            self = arrayValue
        default:
            return nil
        }
    }
}
