# ``SwiftCSVEncoder``

A lightweight library for generating CSV files from your Swift data.

## Overview

CSV files are generated from a collection of objects, with one object correlating to a single row of the CSV.

A ``CSVTable`` definition includes an ordered list of column descriptions, which are then applied in turn to create all the fields of each row of the table.

For example, given a `Doctor` record:

```swift
struct Doctor {
  var id: UUID
  var firstName: String
  var lastName: String
  var description: String?
  var firstEpisode: Date
}
```

we can create a `CSVTable` with the details of each column, using either keypaths or closures that take an instance of a row's data object:

```swift
let doctorsCSV = CSVTable<Doctor>(
  columns: [
    CSVColumn("ID", \.id),
    CSVColumn("Full Name") { doctor in
      let formatter = PersonNameComponentsFormatter()
      let nameComponents = PersonNameComponents(
        givenName: doctor.firstName,
        familyName: doctor.lastName
      )
      return formatter.string(from: nameComponents) 
    },
    CSVColumn("Description", \.description),
    CSVColumn("First appearance", \.firstEpisode)
  ]
)
```

> Tip: As each block will be run once per row of your CSV file, you should avoid doing excessive work (such as creating a new `PersonNameComponentsFormatter` in this example) in your blocks.

Each column definition takes a block that receives the row's object instance, and must return an object that supports the ``CSVEncodable`` protocol. If what needs to be returned is a simple attribute, you can specify a keypath instead. So the following column definitions are equivalent:

```swift
CSVColumn("Description", attribute: { doctor in doctor.description })
CSVColumn("Description") { $0.description }
CSVColumn("Description", \.description)
```

``SwiftCSVEncoder`` adds ``CSVEncodable`` conformance to the Swift primitives `String`, `Int`, `Double`, `Bool` and Foundation data types `Date` and `UUID`. Optional forms are automatically handled, with `nil` values being output as empty cells.

To generate the CSV file, call ``CSVTable/export(rows:)``. The return value is the full CSV file, including a header row. String items will be enclosed in double quotes where needed:

```csv
ID,Full Name,Description,First appearance
1,William Hartnell,Later played by Richard Hurndall and David Bradley,1963-11-23
2,Patrick Troughton,,1966-11-05
3,Jon Pertwee,,1970-01-03
4,Tom Baker,"No relation to the Sixth Doctor, Colin Baker",1974-12-28
```

## Topics

### Defining CSV structure

- ``CSVTable``
- ``CSVColumn``
- ``CSVEncoderConfiguration``

### Protocols

- ``CSVEncodable``
