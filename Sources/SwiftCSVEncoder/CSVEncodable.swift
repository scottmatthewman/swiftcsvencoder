//
//  CSVEncodable.swift
//
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

public protocol CSVEncodable { 
    func encode(configuration: CSVEncoderConfiguration) -> String
}

extension String: CSVEncodable { 
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        self
    }
}

extension Date: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        switch configuration.dateEncodingStrategy {
        case .deferredToDate:
            self.formatted()
        case .iso8601:
            ISO8601DateFormatter().string(from: self)
        case .formatted(let dateFormatter):
            dateFormatter.string(from: self)
        case .custom(let customFunc):
            customFunc(self)
        }
    }
}

extension UUID: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        uuidString
    }
}

extension Int: CSVEncodable { 
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        String(self)
    }
}

extension Double: CSVEncodable { 
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        String(self)
    }
}

extension Optional: CSVEncodable where Wrapped: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        switch self {
        case .none:
            ""
        case .some(let wrapped):
            wrapped.encode(configuration: configuration)
        }
    }
}

extension CSVEncodable {
    internal func escapedOutput(configuration: CSVEncoderConfiguration) -> String {
        let output = self.encode(configuration: configuration)
        if output.contains(",") || output.contains("\"") || output.contains(#"\n"#) || output.hasPrefix(" ") || output.hasSuffix(" ") {
            // Escape existing double quotes by doubling them
            let escapedQuotes = output.replacingOccurrences(of: "\"", with: "\"\"")

            // Wrap the string in double quotes
            return "\"\(escapedQuotes)\""
        } else {
            // No special characters, return as is
            return output
        }
    }
}
