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
    "Select calendar(s) with id <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var selectCalendarIds: [String] = []

  @Option(help: ArgumentHelp(
    "Ignore calendar(s) with id <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var ignoreCalendarIds: [String] = []

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
      selectCalendarIds: selectCalendarIds,
      ignoreCalendarIds: ignoreCalendarIds,
      selectCalendarSources: selectCalendarSources,
      ignoreCalendarSources: ignoreCalendarSources,
      selectCalendarTypes: selectCalendarTypes,
      ignoreCalendarTypes: ignoreCalendarTypes
    )

    let service = EventService(repo: EventRepo())
    let calendars = service.calendars(filter: calendarFilter)

    switch format {
    case .json:
      if let render = calendars.renderAsJson() {
        StdOut.print(render)
      } else {
        StdErr.print("Failed to render calendars as JSON")
      }
    case .plain:
      if let render = calendars.renderAsPlain() {
        StdOut.print(render)
      } else {
        StdErr.print("Failed to render calendars as plain text")
      }
    }
  }
}
