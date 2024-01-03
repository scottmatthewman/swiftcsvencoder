//
//  CSVEncodable.swift
//
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

/// Marks a data type as being natively encodable to a CSV field.
///
/// When defining a ``CSVTable``, each column definition includes a ``CSVColumn/attribute`` function that must
/// a data type that conforms to ``CSVEncodable``.
///
/// SwiftCSVEncoder provides default support for the following data types:
/// * ``Swift/String``
/// * ``Swift/Int``
/// * ``Swift/Double``
/// * ``Swift/Bool``
/// * ``Foundation/Date``
/// * ``Foundation/UUID``
///
/// ``Swift/Optional`` values are also supported. When a value is `nil`/`.none`, it will be represented as an empty value.
/// For example, given a list with an optional **Notes** column:
///
/// ```csv
/// ID,Name,Notes,First episode
/// 1,William Hartnell,Later played by Richard Hurndall and David Bradley,1963-11-23
/// 2,Patrick Troughton,,1966-11-05
/// 3,Jon Pertwee,,1970-01-03
/// ```
///
/// To add conformance to other data types in your own app, implement the required ``encode(configuration:)`` method
/// to return a `String` representation.
public protocol CSVEncodable {
    /// Derive the string representation to be used in the exported CSV.
    ///
    /// Do not call this method from your own code; it is designed to be called from the CSV file generator alone.
    /// - Parameter configuration: The CSV file's encoding configuration. Properties within the configuration may influence the generated string.
    /// - Returns: A `String` representation as it is expected to appear in the CSV file. Note that no special escaping of the string should be applied at this stage.
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
            String(self.timeIntervalSinceReferenceDate)
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

extension Bool: CSVEncodable {
    public func encode(configuration: CSVEncoderConfiguration) -> String {
        let (trueValue, falseValue) = configuration.boolEncodingStrategy.encodingValues

        return self == true ? trueValue : falseValue
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
