import ArgumentParser
import EventKit
import Foundation

/// `plan calendars`
///
/// List available calendars
struct Calendars: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List available calendars"
  )

  @Flag(help: ArgumentHelp(
    "Print debug statements"
  ))
  var debug: Bool = false

  @Option(help: ArgumentHelp(
    "Output format <f>. Available: json or plain",
    valueName: "f"
  )) var format: CalendarFormat = .json

  @Option(help: ArgumentHelp(
    "Select calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var selectCalendars: [String] = []

  @Option(help: ArgumentHelp(
    "Ignore calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var ignoreCalendars: [String] = []

  @Option(help: ArgumentHelp(
    "Select calendar sources <s>. A comma separated list of calendar sources",
    valueName: "s"
  )) var selectCalendarSources: [String] = []

  @Option(help: ArgumentHelp(
    "Ignore calendar sources <s>. A comma separated list of calendar sources",
    valueName: "s"
  )) var ignoreCalendarSources: [String] = []

  @Option(help: ArgumentHelp(
    "Select calendar types <v>. A comma separated list of calendar types. " +
      "Available: [local|caldav|exchange|subscription|birthday]",
    valueName: "v"
  )) var selectCalendarTypes: [EKCalendarType] = []

  @Option(help: ArgumentHelp(
    "Ignore calendar types <v>. A comma separated list of calendar types. " +
      "Available: [local|caldav|exchange|subscription|birthday]",
    valueName: "v"
  )) var ignoreCalendarTypes: [EKCalendarType] = []

  mutating func run() {
    Log.setDebug(debug)

    let calendarFilter = CalendarFilter.build(
      selectCalendars: selectCalendars,
      ignoreCalendars: ignoreCalendars,
      selectCalendarSources: selectCalendarSources,
      ignoreCalendarSources: ignoreCalendarSources,
      selectCalendarTypes: selectCalendarTypes,
      ignoreCalendarTypes: ignoreCalendarTypes
    )

    let service = EventService(repo: EventRepo())
    let calendars = service.calendars(filter: calendarFilter)

    switch format {
    case .json:
      calendars.printAsJson()
    case .plain:
      calendars.printAsPlain()
    }
  }
}
