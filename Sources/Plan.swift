import ArgumentParser
import EventKit
import Foundation

@main
struct Plan: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Unofficial Calendar.app companion CLI to view today's events in various forms",
    subcommands: [
      Add.self,
      Calendars.self,
      Next.self,
      Today.self,
      Usage.self,
    ],
    defaultSubcommand: Usage.self
  )

  mutating func run() {}
}

/// `plan today`
///
/// List today's events
struct Today: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List today's events"
  )

  @Option(help: ArgumentHelp(
    "Ignore events which notes contain the tag <t> eg. 'tag:timeblock'",
    valueName: "t"
  )) var ignoreTag: String = ""

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
    let filterAfter = FiltersAfter.build(ignoreTag: ignoreTag)

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

  mutating func run() {
    Log.setDebug(debug)

    let calendars = EventStore().calendars()

    switch format {
    case .json:
      calendars.printAsJson()
    case .plain:
      calendars.printAsPlain()
    }
  }
}

/// `plan next`
///
/// List next event(s)
struct Next: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List next event"
  )

  @Option(help: ArgumentHelp(
    "Fetch events within <m> minutes",
    valueName: "m"
  )) var within: Int = 60

  @Flag(help: ArgumentHelp(
    "Ignore all day events"
  ))
  var ignoreAllDayEvents: Bool = false

  @Option(help: ArgumentHelp(
    "Ignore titles matching the given pattern <p>",
    valueName: "p"
  )) var ignorePatternTitle: String = ""

  @Option(help: ArgumentHelp(
    "Ignore events which notes contain the tag <t> eg. 'tag:timeblock'",
    valueName: "t"
  )) var ignoreTag: String = ""

  @Option(help: ArgumentHelp(
    "Select calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var selectCalendars: [String]? = nil

  @Option(help: ArgumentHelp(
    "Ignore calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var ignoreCalendars: [String] = []

  @Option(help: ArgumentHelp(
    "Select calendar types <v>. A comma separated list of calendar types",
    valueName: "v"
  )) var selectCalendarTypes: [EKCalendarType] = []

  @Option(help: ArgumentHelp(
    "Ignore calendar types <v>. A comma separated list of calendar types",
    valueName: "v"
  )) var ignoreCalendarTypes: [EKCalendarType] = []

  @Option(help: ArgumentHelp(
    "Output format <f>. Available: json or markdown",
    valueName: "f"
  )) var format: EventFormat = .json

  @Flag(help: ArgumentHelp(
    "Print debug statements"
  ))
  var debug: Bool = false

  mutating func run() {
    Log.setDebug(debug)

    let filterBefore = FiltersBefore.build(
      ignoreAllDayEvents: ignoreAllDayEvents,
      ignorePatternTitle: ignorePatternTitle,
      ignoreCalendars: ignoreCalendars
    )
    let filterAfter = FiltersAfter.build(
      ignoreTag: ignoreTag
    )
    let transformer = Transformers.id

    Log.write(message: "next: About to call eventstore")

    let events = EventStore().next(
      within: within,
      selectCalendars: selectCalendars,
      filterBefore: filterBefore,
      filterAfter: filterAfter
    ).map { event in
      transformer(event)
    }.sorted { $0.schedule.end.inMinutes > $1.schedule.end.inMinutes }

    Log.write(message: "next: Called eventstore")

    var next: [Event]
    if events.count == 0 {
      next = Array()
    } else {
      // prefix crashes if sequence has no elements
      next = Array(events.prefix(upTo: 1))
    }

    switch format {
    case .json:
      next.printAsJson()
    case .markdown:
      next.printAsMarkdown()
    }
  }
}

/// `plan add`
///
/// Add new event
struct Add: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Add new event",
    shouldDisplay: false
  )

  @Argument(help: "Event text to parse")
  var text: String

  mutating func run() {
    var lines: [String] = []
    if text == "-" {
      if StdIn.hasData() {
        lines = StdIn.readLines()
      } else {
        StdErr.print("No input")
        return
      }
    } else {
      lines.append(text)
    }
    // TODO: parse all lines
    if let addEvent = Parser.parse(text: lines[0]) {
      EventStore().add(addEvent: addEvent)
    } else {
      StdErr.print("error parsing")
    }
  }
}

/// `plan usage`
///
/// Show usage and version
struct Usage: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Show help",
    shouldDisplay: false
  )

  @Flag(help: ArgumentHelp(
    "Show version"
  ))
  var version: Bool = false

  mutating func run() {
    if version {
      StdOut.print(Version.value)
    } else {
      StdOut.print(Plan.helpMessage())
    }
  }
}
