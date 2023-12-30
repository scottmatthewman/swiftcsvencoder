//
//  File.swift
//  
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

extension BidirectionalCollection where Element == String {
    var commaDelimited: String { joined(separator: ",") }
    var newlineDelimited: String { joined(separator: #"\n"#) }
}
