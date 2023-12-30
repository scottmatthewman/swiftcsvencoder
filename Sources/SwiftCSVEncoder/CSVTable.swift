//
//  CSVTable.swift
//
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

public struct CSVTable<Record> {
    private var columns: [CSVColumn<Record>]
    private var configuration: CSVEncoderConfiguration

    public init(
        columns: [CSVColumn<Record>],
        configuration: CSVEncoderConfiguration = .default
    ) {
        self.columns = columns
        self.configuration = configuration
    }

    public func export(rows: any Sequence<Record>) -> String {
        ([headers] + allRows(rows: rows)).newlineDelimited
    }

    // MARK: -

    private var headers: String {
        columns.map { $0.header.escapedOutput(configuration: configuration) }.commaDelimited
    }

    private func allRows(rows: any Sequence<Record>) -> [String] {
        rows.map { row in
            columns.map { $0.attribute(row).escapedOutput(configuration: configuration) }.commaDelimited
        }
    }
}
