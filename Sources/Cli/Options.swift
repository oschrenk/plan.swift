import ArgumentParser
import EventKit
import Foundation

struct AllOptions {
  let calendar: CalendarOptions
  let events: EventOptions
  let general: Options
}

struct CalendarOptions: ParsableArguments {
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
}

struct EventOptions: ParsableArguments {
  @Flag(help: ArgumentHelp(
    "Ignore all day events"
  ))
  var ignoreAllDayEvents: Bool = false

  @Flag(help: ArgumentHelp(
    "Select all day events"
  ))
  var selectAllDayEvents: Bool = false

  @Option(help: ArgumentHelp(
    "Ignore titles matching the given pattern <p>",
    valueName: "p"
  )) var ignorePatternTitle: String = ""

  @Option(help: ArgumentHelp(
    "Select titles matching the given pattern <p>",
    valueName: "p"
  )) var selectPatternTitle: String = ""

  @Option(help: ArgumentHelp(
    "Ignore events which notes contain the tag <t> " +
      "eg. 'tag:timeblock'. A comma separated list of tags",
    valueName: "t"
  )) var ignoreTags: [String] = []

  @Option(help: ArgumentHelp(
    "Select events which notes contain the tag <t> " +
      "eg. 'tag:timeblock'. A comma separated list of tags",
    valueName: "t"
  )) var selectTags: [String] = []

  @Option(help: ArgumentHelp(
    "Minimum (inclusive) number <n> of attendees",
    valueName: "n"
  )) var minNumAttendees: Int?

  @Option(help: ArgumentHelp(
    "Maximum (inclusive) number <n> of attendees",
    valueName: "n"
  )) var maxNumAttendees: Int?

  @Option(help: ArgumentHelp(
    "Minimum (inclusive) length <m> (in minutes) of duration",
    valueName: "m"
  )) var minDuration: Int?

  @Option(help: ArgumentHelp(
    "Maximum (inclusive) length <m> (in minutes) of duration",
    valueName: "m"
  )) var maxDuration: Int?
}

/// Shared options
struct Options: ParsableArguments {
  @Option(help: ArgumentHelp(
    "Template path <p>",
    valueName: "p"
  )) var templatePath: String = ""

  @Option(help: ArgumentHelp(
    "Sort order(s) <s>. " +
      "A comma separated list of fields and optional direction " +
      "`field[:asc|desc]`. " +
      "Available fields: [" +
      Sorting.AllowedFields.joined(separator: ", ") + "]",
    valueName: "s"
  )) var sortBy: [Order] = []

  @Flag(help: ArgumentHelp(
    "Print debug statements"
  ))
  var debug: Bool = false
}
