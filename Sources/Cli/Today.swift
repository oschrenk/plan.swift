import ArgumentParser
import EventKit
import Foundation

/// `plan today`
///
/// List today's events
struct Today: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List today's events"
  )

  @Option(help: ArgumentHelp(
    "Ignore events which notes contain the tag <t> eg. 'tag:timeblock'. A comma separated list of tags.",
    valueName: "t"
  )) var ignoreTags: [String] = []

  @Option(help: ArgumentHelp(
    "Output format <f>. Available: json or markdown",
    valueName: "f"
  )) var format: EventFormat = .json

  @Flag(help: ArgumentHelp(
    "Print debug statements"
  ))
  var debug: Bool = false

  @Option(help: ArgumentHelp(
    "Select calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var selectCalendars: [String] = []

  @Option(help: ArgumentHelp(
    "Ignore calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var ignoreCalendars: [String] = []

  mutating func run() {
    Log.setDebug(debug)

    let filterBefore = FiltersBefore.build(
      ignoreAllDayEvents: false,
      ignorePatternTitle: "",
      ignoreCalendars: ignoreCalendars
    )
    let filterAfter = FiltersAfter.build(ignoreTags: ignoreTags)

    let events = EventStore().today(
      selectCalendars: selectCalendars,
      filterBefore: filterBefore,
      filterAfter: filterAfter
    )

    switch format {
    case .json:
      events.printAsJson()
    case .markdown:
      events.printAsMarkdown()
    }
  }
}
