//
//  CSVEncodableTests.swift
//  
//
//  Created by Scott Matthewman on 30/12/2023.
//

import XCTest
import SwiftCSVEncoder

final class CSVEncodableTests: XCTestCase {
    let date = ISO8601DateFormatter().date(from: "2023-11-07T18:34:21+0100")!

    func testStringEncodesToItself() {
        let sourceString = #"This is a source string, with commas and "double quotes" in it"#

        XCTAssertEqual(sourceString, sourceString.encode(configuration: .default), "String should not change when encoded")
    }

    func testIntEncodesToStringRepresentation() {
        let sourceInt = 12_345_678

        XCTAssertEqual(sourceInt.encode(configuration: .default), "12345678", "Int should encode as a plain number without formatting")
    }

    func testDoubleEncodesToStringRepresentation() {
        let sourceDouble = 12_345.678_901

        XCTAssertEqual(sourceDouble.encode(configuration: .default), "12345.678901", "Double should encode as a plain number without formatting")
    }

    func testOptionalEncodesToEmptyStringWhenNil() {
        let sourceInt: Int? = nil

        XCTAssertEqual(sourceInt.encode(configuration: .default), "", "A nil optional value should encode as an empty string")
    }

    func testOptionalEncodesToWrappedValueWhenNotNil() {
        let sourceInt: Int? = 12_345

        XCTAssertEqual(sourceInt.encode(configuration: .default), "12345", "A non-nil optional value should encode its wrapped value")
    }

    func testUUIDEncodesToStringRepresentation() {
        let uuid = UUID()

        XCTAssertEqual(uuid.encode(configuration: .default), uuid.uuidString, "A UUID should encode as its uuidString")
    }

    func testDateEncodesWithISO8601InUTCByDefault() {
        XCTAssertEqual(date.encode(configuration: .default), "2023-11-07T17:34:21Z")
    }

    func testDateEncodesWithDeferredFormat() {
        let configuration = CSVEncoderConfiguration(dateEncodingStrategy: .deferredToDate)

        // timeIntervalSinceReferenceDate
        XCTAssertEqual(date.encode(configuration: configuration), "721071261.0")
    }

    func testDateEncodesWithFormatter() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm:ss -- dd-MM-yyyy"

        let configuration = CSVEncoderConfiguration(dateEncodingStrategy: .formatted(dateFormatter))

        XCTAssertEqual(date.encode(configuration: configuration), "17:34:21 -- 07-11-2023")
    }

    func testDateEncodedWithCustomClosure() {
        let configuration = CSVEncoderConfiguration(dateEncodingStrategy: .custom({ date in "Custom returned value" }))

        XCTAssertEqual(date.encode(configuration: configuration), "Custom returned value")
    }

    func testBoolTrueEncodedAsString() {
        let input: Bool = true

        XCTAssertEqual(input.encode(configuration: .default), "true")
    }

    func testBoolFalseEncodedAsString() {
        let input: Bool = false

        XCTAssertEqual(input.encode(configuration: .default), "false")
    }
}
