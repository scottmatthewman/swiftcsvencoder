//
//  CSVTable.swift
//
//
//  Created by Scott Matthewman on 29/12/2023.
//

import Foundation

/**
 The definition of a CSV file structure.

 CSV tables are keyed to a specific record type, with each row of the CSV file presumed to map a
 single item of that type. The ``columns`` property describes the columns of the CSV file, left to right,
 and how the values are derived from each row's source record.

 An additional ``configuration`` property encapsulates decisions that may affect how the overall
 CSV file is formatted.

 ```swift
 struct Person {
   var firstName: String
   var lastName: String
   var occupation: String?
   var employer: Business?
   var tags: [String]
 }

 struct Business {
   var name: String
   var description: String?
 }

 let peopleTable = CSVTable<Person>(
   columns: [
     CSVColumn("First name", \.firstName),
     CSVColumn("Last name", \.lastName),
     CSVColumn("Occupation", \.occupation),
     CSVColumn("Employer") { $0.business?.name },
     CSVColumn("Tags") { $0.tags.joined(separator: ", ") }
   ],
   configuration: .default
 )


 let people: [Person] = [
   /* ..definition of `Person` objects */
 ]

 let csvTable = peopleTable.export(rows: people)

 ```

 Note that ``CSVTable/export(rows:)`` only serializes the supplied data into a `String` object. It is up to the calling application to persist that text as a file.

*/
public struct CSVTable<Record> {
    /// A description of all the columns of the CSV file, order from left to right.
    public private(set) var columns: [CSVColumn<Record>]
    /// The set of configuration parameters to use while encoding attributes and the whole file.
    ///
    /// The default configuration is ``CSVEncoderConfiguration/default``, which provides a date
    /// encoding strategy of ``CSVEncoderConfiguration/DateEncodingStrategy-swift.enum/iso8601``.
    public private(set) var configuration: CSVEncoderConfiguration
    
    /// Create a CSV table definition.
    /// - Parameters:
    ///   - columns: a list of ``CSVColumn`` records describing each column of the CSV file output
    ///   - configuration: the configuration to use when building the CSV file
    public init(
        columns: [CSVColumn<Record>],
        configuration: CSVEncoderConfiguration = .default
    ) {
        self.columns = columns
        self.configuration = configuration
    }
    
    /// Constructs a CSV text file structure from the given rows of data.
    /// - Parameter rows: a collection of objects which will be output, in order, as rows of the CSV file
    /// - Returns: A String representing all supplied rows as a CSV file, including a header row
    public func export(
        rows: any Sequence<Record>
    ) -> String {
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
