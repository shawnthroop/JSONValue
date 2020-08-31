//
//  JSONValueKey.swift
//  Created by Shawn Throop on 31.08.20.
//

public protocol JSONValueKey {
    
    /// The intermediate raw JSON type.
    associatedtype RawValue: JSONValueRepresentable
    
    /// The type made accessible by the receiver.
    associatedtype Value
    
    /// Creates an instance of Value from the given raw value.
    static func value(from rawValue: RawValue) -> Value?
    
    /// Provides a RawValue representation for the given value.
    static func rawValue(for value: Value) -> RawValue
}
