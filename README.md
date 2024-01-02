# SwiftCSVEncoder

A Swift package that allows for the creation of CSV files.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fscottmatthewman%2Fswiftcsvencoder%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/scottmatthewman/swiftcsvencoder) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fscottmatthewman%2Fswiftcsvencoder%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/scottmatthewman/swiftcsvencoder)

## Rationale

Neither Swift nor Apple's application libraries contain a standardised method of converting data to CSV format for export. A number of packages already exist, but I wanted to build my own minimal, reusable library.

## Features

1. **Not coupled to root object structure.**

   `Codable` is great but is limited to a single coding representation per object. It's also created with hierarchical representations – dictionaries and arrays inside other dictionaries or arries - in mind, whereas CSV is by its nature flat in structure.
   
    I also need CSV outputs with different columns for different purposes, but which might each serialize the same object with different columns. So SwiftCSVEncoder provides a `CSVTable` object that defines which columns to use:

   ```swift
   let table: CSVTable<Customer> = CSVTable(
     columns: [
       CSVColumn("Name") { $0.name },
       CSVColumn("Email") { $0.email },
       CSVColumn("Order count") { $0.orders?.count ?? 0 }
     ]
   )
   ```

   Where a column's attribute block does nothing but access a property, a keyPath-based shortcut may be used.

   ```swift
   CSVColumn("Name", \.name)
   ```

2. **Always include column headers as the first row.**

3. **Automatic quoting of strings, but only when needed.**

   Including freeform text in CSVs is fraught with difficulties because not all CSV importers handle things like new lines or embedded special characters (`"`, `,`) in the same way. SwiftCSVEncoder currently supports only one set of encoding rules for strings:

   * If the text includes a comma (`,`), a newline (`\n`) or double quotes (`"`), or if it has leading or trailing whitespace, then the whole string is enclosed in double quotation marks.
   * Any double quotes within the text are escaped by being doubled, so the text `This is C.S.Lewis's sequel to "The Lion, The Witch and the Wardrobe"` would be emitted as `"This is C.S.Lewis's sequel to ""The Lion, The Witch and the Wardrobe"""`.

4. **Default delimiter and line-ending**

   The CSVs emitted by SwiftCSVEncoder separate fields only by commas. Each line is terminated by the `\r\n` character. If you want different options, then (for now) look elsewhere.

5. **Optional control over `Date` format**

   `Date` objects are natively handled, but the format in which they are converted to strings might vary. Each `CSVTable` supports a configuration object that includes a `dateEncodingStrategy`. The default is to use a full date/time ISO 8601-compliant format.

6. **Only support in-memory data creation**

   `SwiftCSVEncoder` only creates a string representation of the whole CSV file in memory. The calling application needs to handle saving the data to an appropriate location.
