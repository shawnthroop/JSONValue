//
//  JSONValue.swift
//  Created by Shawn Throop on 29.08.20.
//

/// A typesafe model of valid JSON types.
public enum JSONValue: Equatable {
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    case object(JSONObject)
    case array(JSONArray)
    case null
}


public typealias JSONObject = [String: JSONValue]
public typealias JSONArray = [JSONValue]


extension JSONValue: JSONValueStorage {
    
    public var jsonValue: JSONValue {
        get { self }
        set { self = newValue }
    }
}


extension JSONObject: JSONValueStorage, JSONValueRepresentable {
    
    public init?(json: JSONValue) {
        switch json {
        case .object(let value):
            self = value
        default:
            return nil
        }
    }
    
    public func asJSON() -> JSONValue { .object(self) }
}


extension JSONArray: JSONValueStorage, JSONValueRepresentable {
    
    public init?(json: JSONValue) {
        switch json {
        case .array(let value):
            self = value
        default:
            return nil
        }
    }
    
    public func asJSON() -> JSONValue { .array(self) }
}


extension JSONValueStorage where Self: JSONValueRepresentable {
    
    public var jsonValue: JSONValue {
        get { asJSON() }
        set {
            if let newValue = Self(json: newValue) {
                self = newValue
            }
        }
    }
}


extension JSONValue: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let objectValue = try? container.decode(JSONObject.self) {
            self = .object(objectValue)
        } else if let arrayValue = try? container.decode(JSONArray.self) {
            self = .array(arrayValue)
        } else {
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: """
            Data could not be decoded from an unsupported type.
            """)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .null:
            try container.encodeNil()
        case .bool(let boolValue):
            try container.encode(boolValue)
        case .int(let intValue):
            try container.encode(intValue)
        case .double(let doubleValue):
            try container.encode(doubleValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        case .object(let objectValue):
            try container.encode(objectValue)
        case .array(let arrayValue):
            try container.encode(arrayValue)
        }
    }
}


extension JSONValue {
    
    public init<T>(representation: T) where T: JSONValueRepresentable {
        self = representation.asJSON()
    }
}


extension JSONValue: ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral {
    
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
    
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
    
    public init(floatLiteral value: Double) {
        self = .double(value)
    }

    public init(stringLiteral value: String) {
        self = .string(value)
    }
}


extension JSONValue: ExpressibleByDictionaryLiteral, ExpressibleByArrayLiteral {
    
    public init(dictionaryLiteral elements: (String, JSONValueRepresentable)...) {
        self = .object(elements.reduce(into: [:]) { $0[$1.0] = $1.1.asJSON() })
    }
    
    public init(arrayLiteral elements: JSONValueRepresentable...) {
        self = .array(elements.map { $0.asJSON() })
    }
}


extension JSONValue: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .bool(let boolValue):
            return boolValue.description
        case .int(let intValue):
            return intValue.description
        case .double(let doubleValue):
            return doubleValue.description
        case .string(let stringValue):
            return stringValue.description
        case .object(let objectValue):
            return objectValue.description
        case .array(let arrayValue):
            return arrayValue.description
        case .null:
            return "null"
        }
    }
}
