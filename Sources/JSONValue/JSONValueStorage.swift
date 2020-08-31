//
//  JSONValueStorage.swift
//  Created by Shawn Throop on 30.08.20.
//

/// A type capable of storing JSONValue instances.
public protocol JSONValueStorage {
    
    /// A mutable value representing the reciever.
    var jsonValue: JSONValue { get set }
}



extension JSONValueStorage {
    
    public var boolValue: Bool? {
        get { value() }
        set { setValue(newValue) }
    }

    public var intValue: Int? {
        get { value() }
        set { setValue(newValue) }
    }

    public var doubleValue: Double? {
        get { value() }
        set { setValue(newValue) }
    }

    public var stringValue: String? {
        get { value() }
        set { setValue(newValue) }
    }

    public var objectValue: JSONObject? {
        get { value() }
        set { setValue(newValue) }
    }

    public var arrayValue: JSONArray? {
        get { value() }
        set { setValue(newValue) }
    }
    
    public subscript(key: String) -> JSONValue? {
        get { objectValue?.value(forKey: key) }
        set { objectValue?.set(newValue, forKey: key) }
    }
    
    public subscript<T>(key: String) -> T? where T: JSONValueRepresentable {
        get { self[key].value() }
        set { self[key].setValue(newValue) }
    }
    
    
    public subscript(index: Int) -> JSONValue? {
        get { arrayValue?.element(at: index) }
        set { arrayValue?.setElement(newValue, at: index) }
    }
    
    public subscript<T>(index: Int) -> T? where T: JSONValueRepresentable {
        get { self[index].value() }
        set { self[index].setValue(newValue) }
    }
    
    
    public func value<T>(of _: T.Type = T.self) -> T? where T: JSONValueRepresentable {
        T.init(json: jsonValue)
    }
    
    public mutating func setValue<T>(_ newValue: T?) where T: JSONValueRepresentable {
        if let newJSON = newValue?.asJSON() {
            jsonValue = newJSON
        }
    }
}



extension JSONValueStorage {
    
    public subscript<T>(key: T.Type) -> T.Value? where T: JSONValueKey {
        get { value(for: T.self) }
        set { set(newValue, forType: T.self) }
    }
    
    
    public func value<T>(for _: T.Type) -> T.Value? where T: JSONValueKey {
        value(of: JSONValueKeyRepresenation<T>.self)?.value
    }
    
    public mutating func set<T>(_ newValue: T.Value?, forType _: T.Type) where T: JSONValueKey {
        setValue(newValue.map(JSONValueKeyRepresenation<T>.init(value:)))
    }
}



extension Optional: JSONValueStorage where Wrapped: JSONValueStorage {
    
    public var jsonValue: JSONValue {
        get {
            switch self {
            case .some(let wrapped):
                return wrapped.jsonValue
            case .none:
                return .null
            }
        }
        set {
            switch self {
            case .some(var wrapped):
                wrapped.jsonValue = newValue
                self = .some(wrapped)
            case .none:
                return
            }
        }
    }
}



private extension JSONObject {
    
    func value(forKey key: Key) -> Value? {
        self[key]
    }
    
    mutating func set(_ newValue: Value?, forKey key: Key) {
        if let newValue = newValue {
            updateValue(newValue, forKey: key)
            
        } else {
            removeValue(forKey: key)
        }
    }
}


private extension JSONArray {
    
    func element(at index: Index) -> Element {
        self[index]
    }
    
    mutating func setElement(_ element: Element?, at index: Index) {
        if let element = element {
            self[index] = element
            
        } else {
            self.remove(at: index)
        }
    }
}


private struct JSONValueKeyRepresenation<A: JSONValueKey> {
    let value: A.Value
}


extension JSONValueKeyRepresenation: JSONValueRepresentable {
    
    init?(json: JSONValue) {
        guard let value = A.RawValue(json: json).flatMap(A.value(from:)) else {
            return nil
        }
        
        self.init(value: value)
    }
    
    func asJSON() -> JSONValue {
        A.rawValue(for: value).asJSON()
    }
}
