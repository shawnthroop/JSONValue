//
//  Foundation+JSONValue.swift
//  Created by Shawn Throop on 31.08.20.
//

import Foundation

// MARK: - Date

extension JSONValueStorage {
    
    public var dateValue: Date? {
        get { self[DateKey.self] }
        set { self[DateKey.self] = newValue }
    }
    
    public var iso8601DateValue: Date? {
        get { self[ISO8601DateKey.self] }
        set { self[ISO8601DateKey.self] = newValue }
    }
}


public struct DateKey: JSONValueKey {
        
    public static func value(from rawValue: Double) -> Date? {
        Date(timeIntervalSinceReferenceDate: rawValue)
    }
    
    public static func rawValue(for value: Date) -> Double {
        value.timeIntervalSinceReferenceDate
    }
}


public struct ISO8601DateKey: JSONValueKey {
    
    private static let formatter = ISO8601DateFormatter()
        
    public static func value(from rawValue: String) -> Date? {
        formatter.date(from: rawValue)
    }
    
    public static func rawValue(for value: Date) -> String {
        formatter.string(from: value)
    }
}



// MARK: - URL

extension JSONValueStorage {
    
    public var urlValue: URL? {
        get { self[URLKey.self] }
        set { self[URLKey.self] = newValue }
    }
}


public struct URLKey: JSONValueKey {
    
    public static func value(from rawValue: String) -> URL? {
        URL(string: rawValue)
    }
    
    public static func rawValue(for value: URL) -> String {
        value.absoluteString
    }
}
