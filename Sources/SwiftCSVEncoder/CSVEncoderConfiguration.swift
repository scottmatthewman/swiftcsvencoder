//
//  File.swift
//  
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

/// A set of decisions about how to encode data for a given ``CSVTable``.
///
/// Currently this is restricted solely to a strategy for encoding `Date` values.
public struct CSVEncoderConfiguration {
    /// The strategy to use when encoding dates.
    ///
    /// The default strategy is the ``DateEncodingStrategy-swift.enum/iso8601`` strategy.
    public private(set) var dateEncodingStrategy: DateEncodingStrategy = .iso8601
    
    /// The strategy to use when encoding Boolean values.
    ///
    /// The default strategy is the ``BoolEncodingStrategy-swift.enum/trueFalse`` strategy.
    public private(set) var boolEncodingStrategy: BoolEncodingStrategy = .trueFalse

    /// Creates a new instance of ``CSVEncoderConfiguration`` with the requisite configuration values
    /// - Parameter dateEncodingStrategy: The strategy to use when encoding dates
    /// - Parameter boolEncodingStrategy: The strategy to use when encoding Boolean values
    public init(
        dateEncodingStrategy: DateEncodingStrategy = .iso8601,
        boolEncodingStrategy: BoolEncodingStrategy = .trueFalse
    ) {
        self.dateEncodingStrategy = dateEncodingStrategy
        self.boolEncodingStrategy = boolEncodingStrategy
    }
    
    /// The strategy to use when encoding `Date` objects for CSV output.
    public enum DateEncodingStrategy {
        /// The strategy that uses formatting from the `Date` structure.
        case deferredToDate
        /// The strategy that formats dates according to the ISO 8601 and RFC 3339 standards.
        case iso8601
        /// The strategy that defers formatting settings to a supplied date formatter.
        case formatted(DateFormatter)
        /// The strategy that formats custom dates by calling a user-defined function.
        /// - Parameter custom: A closure that receives the `Date` to encode, and returns the `String` to include in the CSV output.
        case custom(@Sendable (Date) -> String)
    }

    /// The strategy to use when encoding `Bool` objects for CSV output.
    public enum BoolEncodingStrategy {
        /// The strategy that emits `true` and `false` for Boolean fields
        case trueFalse
        /// The strategy that emits `TRUE` and `FALSE` for Boolean fields
        case trueFalseUppercase
        /// The strategy that emite `yes` and `no` for Boolean fields
        case yesNo
        /// The strategy that emits `YES` and `NO` for Boolean fields
        case yesNoUppercase
        /// The strategy that emits `1` and `0` for Boolean fields
        case integer
        /// A custom strategy that emitss the custom supplied strings for Boolean fields
        case custom(true: String, false: String)
    }

    /// A default set of configuration values.
    ///
    /// This configuration set will be used when a ``CSVTable`` is initialized with setting a custom
    /// configuration.
    public static var `default`: CSVEncoderConfiguration = CSVEncoderConfiguration()
}
