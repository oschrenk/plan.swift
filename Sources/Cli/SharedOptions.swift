import ArgumentParser
import EventKit
import Foundation

/// Shared arguments between `today` and `next` subcommands.
struct SharedOptions: ParsableArguments {
  @Flag(help: ArgumentHelp(
    "Ignore all day events"
  ))
  var ignoreAllDayEvents: Bool = false

  @Option(help: ArgumentHelp(
    "Ignore titles matching the given pattern <p>",
    valueName: "p"
  )) var ignorePatternTitle: String = ""

  @Option(help: ArgumentHelp(
    "Ignore events which notes contain the tag <t> " +
      "eg. 'tag:timeblock'. A comma separated list of tags.",
    valueName: "t"
  )) var ignoreTags: [String] = []

  @Option(help: ArgumentHelp(
    "Select calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var selectCalendars: [String] = []

  @Option(help: ArgumentHelp(
    "Ignore calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var ignoreCalendars: [String] = []

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

  @Option(help: ArgumentHelp(
    "Template path <p>.",
    valueName: "p"
  )) var templatePath: String = ""

  @Flag(help: ArgumentHelp(
    "Print debug statements"
  ))
  var debug: Bool = false
}