# Exporting CSV from SwiftUI

Generating CSV data is one thing. How you build the export into your app is another matter.

## Overview

``SwiftCSVEncoder`` only includes code to generate a CSV file as a string. If you include the library
into your application, it's up to you how you incorporate the exporting of documents into your app.

SwiftUI includes several useful components that make the exporting process relatively straightforward. 
The following is an example of one approach.

> Tip: This walkthrough includes technologies first introduced in iOS 16.0 and 17.0, and the equivalent OS versions on Apple's other platforms.

## Walkthrough

### 1. Create an object that represents your exported data

To represent your data file that will be exported, you need an object that can represent just the data 
you're exporting. It's possible that you already have such an object, but it may also make sense to cerate 
a separate object and pass in the data to be exported.

```swift
struct CSVFile {
  var events: [Event]

  init(events: [Event]) {
    self.events = events
  }
}
```

### 2. Add a method to generate the CSV data

```swift
import SwiftCSVEncoder

extension CSVFile {
  func csvData() -> String {
    let table = CSVTable<Event>(
      columns: [
        CSVColumn("Title", \.title),
        CSVColumn("Date", \.date),
        CSVColumn("Venue Name", \.venueName),
        CSVColumn("City", \.city)
      ], 
      configuration: CSVEncoderConfiguration(dateDecodingStrategy: .iso8601) 
    )

    return table.export(rows: events)
  }
}
```

### 3. Make the object conform to `Transferable`

The [`Transferable`](https://developer.apple.com/documentation/coretransferable/transferable#) protocol
simplifies how to manage interaction of your app's data with operating system APIs, including file export.

To make your CSV file exportable, import the `CoreTransferable` library and add conformance.

```swift
import CoreTransferable

extension CSVFile: Transferable {
  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(exportedContentType: .commaSeparatedText) { file in
      Data(file.csvData().utf8)
    }
  }
}
```

### 4. Add an export button to your app

SwiftUI offers a `fileExporter` modifier which you attach to a parent view in the same way you would to
a sheet, full screen cover, etc.

It requires two `@State` variables: a `Boolean` to cover whether or not to show the export dialog, and an
instance of our `CSVFile`. In this example, we only need our file while the export process is going on 
(because it contains a copy of the data generated just for the purpose) so we can create it just before 
it's needed.

We add an **Export** button that sets these two values, and add the `fileExporter` modifier to make use of 
them.

```swift
import SwiftUI

struct ContentView {
  // assume this is the source for our app's data
  @EnvironmentObject var dataModel: DataModel

  @State private var showingExporter = false
  @State private var csvFile: CSVFile?

  var body: some Body {
    List(dataModel.events) { event in
      // display the list of events 
    }
    .toolbar {
      Button("Export") {
        csvFile = CSVFile(events: dataModel.events)
        showingExporter = true
      }
    }
    .fileExporter(
      isPresented: $showingExporter,
      item: csvFile,
      contentTypes: [.commaSeparatedText]
    )
  }
}
```

> NOTE: When the export operation completes or the user cancels, `showingExporter` will revert to `false` 
  but `csvFile` will not be removed, so the `CSVFile` object will still be in memory. In many circumstances
  this may be okay. You may optionally choose to implement the `fileExporter` modifier's `onCompletion` and
  `onCancellation` methods, and set `csvFile = nil` to deallocate the file.
