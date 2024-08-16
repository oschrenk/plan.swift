import ArgumentParser
import Foundation

extension Array: ExpressibleByArgument where Element == String {
  public init?(argument: String) {
    self = argument.split(separator: ",").map { String($0) }
  }
}

@main
struct Plan: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Unofficial Calendar.app companion CLI to view today's events in various forms",
    subcommands: [
      Add.self,
      Calendars.self,
      Next.self,
      Today.self,
    ],
    defaultSubcommand: Next.self
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

  @Option(help: ArgumentHelp(
    "Verbosity <v>. Available: quiet or normal",
    valueName: "v"
  )) var verbosity: Verbosity = .quiet

  @Option(help: ArgumentHelp(
    "Ignore calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var ignoreCalendars: [String] = []

  mutating func run() {
    Log.verbosity = verbosity

    let filterBefore = Refine.before(
      ignoreAllDayEvents: false,
      ignorePatternTitle: "",
      ignoreCalendars: ignoreCalendars
    )
    let filterAfter = Refine.after(ignoreTag: ignoreTag)

    let events = EventStore().today(
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

  @Option(help: ArgumentHelp(
    "Verbosity <v>. Available: quiet or normal",
    discussion: "Verbosity level",
    valueName: "v"
  )) var verbosity: Verbosity = .quiet

  @Option(help: ArgumentHelp(
    "Output format <f>. Available: json or plain",
    valueName: "f"
  )) var format: CalendarFormat = .json

  mutating func run() {
    Log.verbosity = verbosity

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
    "Ignore calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var ignoreCalendars: [String] = []

  @Option(help: ArgumentHelp(
    "Output format <f>. Available: json or markdown",
    valueName: "f"
  )) var format: EventFormat = .json

  @Option(help: ArgumentHelp(
    "Verbosity <v>. Available: quiet or normal",
    valueName: "v"
  )) var verbosity: Verbosity = .quiet

  mutating func run() {
    Log.verbosity = verbosity

    let filterBefore = Refine.before(
      ignoreAllDayEvents: ignoreAllDayEvents,
      ignorePatternTitle: ignorePatternTitle,
      ignoreCalendars: ignoreCalendars
    )
    let filterAfter = Refine.after(
      ignoreTag: ignoreTag
    )
    let transformer = Transformers.id

    let events = EventStore().next(
      within: within,
      filterBefore: filterBefore,
      filterAfter: filterAfter
    ).map { event in
      transformer(event)
    }.sorted { $0.endsIn > $1.endsIn }

    var next: [Event]
    if events.count == 0 {
      next = Array()
    }

    // prefix crashes if sequence has no elements
    next = Array(events.prefix(upTo: 1))

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

  mutating func run() {
    print("Add new event")
  }
}
