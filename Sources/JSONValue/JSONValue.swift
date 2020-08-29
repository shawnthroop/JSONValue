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
}

public typealias JSONObject = [String: JSONValue]
public typealias JSONArray = [JSONValue]


extension JSONValue {
    
    public subscript(key: String) -> JSONValue? {
        get { objectValue?[key] }
        set { objectValue?[key] = newValue }
    }
    
    public subscript<T>(key: String) -> T? where T: JSONValueRepresentable {
        get { self[key].flatMap(T.init(json:)) }
        set { self[key] = newValue?.jsonValue }
    }
    
    public subscript<T>(key: String, type type: T.Type) -> T? where T: JSONValueRepresentable {
        self[key]
    }
    
    
    public var boolValue: Bool? {
        Bool(json: self)
    }
    
    public var intValue: Int? {
        Int(json: self)
    }
    
    public var doubleValue: Double? {
        get { Double(json: self) }
        set { set(newValue.map(JSONValue.double)) }
    }
    
    public var stringValue: String? {
        get { String(json: self) }
        set { set(newValue.map(JSONValue.string)) }
    }
    
    public var objectValue: JSONObject? {
        get { JSONObject(json: self) }
        set { set(newValue.map(JSONValue.object)) }
    }
    
    public var arrayValue: JSONArray? {
        get { JSONArray(json: self) }
        set { set(newValue.map(JSONValue.array)) }
    }
    
    private mutating func set(_ newValue: Self?) {
        if let newValue = newValue {
            self = newValue
        }
    }
}


extension Optional where Wrapped == JSONValue {
    
    public subscript(key: String) -> JSONValue? {
        switch self {
        case .object(let objectValue):
            return objectValue[key]
        default:
            return nil
        }
    }
}


extension JSONValue: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let boolValue = try? container.decode(Bool.self) {
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
    
    public init(dictionaryLiteral elements: (String, JSONValue)...) {
        self = .object(elements.reduce(into: [:]) { $0[$1.0] = $1.1 })
    }
    
    public init(arrayLiteral elements: JSONValue...) {
        self = .array(elements)
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
        }
    }
}
