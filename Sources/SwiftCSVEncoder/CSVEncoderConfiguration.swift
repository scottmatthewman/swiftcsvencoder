//
//  File.swift
//  
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

public struct CSVEncoderConfiguration {
    var dateEncodingStrategy: DateEncodingStrategy = .iso8601

    public init(dateEncodingStrategy: DateEncodingStrategy) {
        self.dateEncodingStrategy = dateEncodingStrategy
    }

    public enum DateEncodingStrategy {
        case deferredToDate
        case iso8601
        case formatted(DateFormatter)
        case custom((Date) -> String)
    }

    public static var standard: CSVEncoderConfiguration = .init(dateEncodingStrategy: .iso8601)
}
