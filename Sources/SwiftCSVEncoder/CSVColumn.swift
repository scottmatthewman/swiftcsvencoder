//
//  CSVColumn.swift
//  
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

public struct CSVColumn<Record> {
    var header: String
    var attribute: (Record) -> CSVEncodable

    init(
        _ header: String,
        attribute: @escaping (Record) -> CSVEncodable
    ) {
        self.header = header
        self.attribute = attribute
    }
}
