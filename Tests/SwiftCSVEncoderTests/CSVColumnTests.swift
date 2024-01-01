//
//  CSVColumnTests.swift
//  
//
//  Created by Scott Matthewman on 30/12/2023.
//

import SwiftCSVEncoder
import XCTest

final class CSVColumnTests: XCTestCase {
    struct TestRecord {
        var title: String
        var date: Date
        var intValue: Int
    }

    func testColumnHeaderIsReadable() {
        let column = CSVColumn<TestRecord>("Title") { $0.title }

        XCTAssertEqual(column.header, "Title")
    }

    func testColumnAttributeResolves() {
        let column = CSVColumn<TestRecord>("Title") { $0.title }
        let testRecord = TestRecord(title: "Doctor Who", date: .now, intValue: 3)

        let resolvedColumn = column.attribute(testRecord)
        XCTAssertEqual(resolvedColumn.encode(configuration: .default), "Doctor Who")
    }

    func testColumnAttributeCanBeKeyPath() {
        let column = CSVColumn<TestRecord>("Title", \.title)
        let testRecord = TestRecord(title: "Doctor Who", date: .now, intValue: 3)

        let resolvedColumn = column.attribute(testRecord)
        XCTAssertEqual(resolvedColumn.encode(configuration: .default), "Doctor Who")
    }
}
