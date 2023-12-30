//
//  CSVColumn.swift
//  
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

public struct CSVColumn<Record> {
    public private(set) var header: String
    public private(set) var attribute: (Record) -> CSVEncodable

    init(
        _ header: String,
        attribute: @escaping (Record) -> CSVEncodable
    ) {
        self.header = header
        self.attribute = attribute
    }
}
