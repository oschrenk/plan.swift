import ArgumentParser
import Foundation

@main
struct Plan: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Unofficial Calendar.app companion CLI to view today's events in various forms",
    subcommands: [
      Today.self,
      Next.self,
      Calendars.self,
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
    "Ignore events which notes contain the tag <t> eg. 'timeblock' ",
    valueName: "t"
  )) var rejectTag: String = ""

  @Option(help: ArgumentHelp(
    "Output format <f>. Available: json or markdown ",
    valueName: "f"
  )) var format: EventFormat = .json

  @Option(help: ArgumentHelp(
    "Verbosity <v>. Available: quiet or normal ",
    valueName: "v"
  )) var verbosity: Verbosity = .quiet

  mutating func run() {
    Log.verbosity = verbosity

    let events = Service().today(rejectTag: rejectTag)
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
    "Verbosity <v>. Available: quiet or normal ",
    discussion: "Verbosity level",
    valueName: "v"
  )) var verbosity: Verbosity = .quiet

  mutating func run() {
    Log.verbosity = verbosity

    Service().calendars().printAsJson()
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
    "Fetch events within <m> minutes.",
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
    "Reject events which notes contain the tag <t> eg. 'timeblock' ",
    valueName: "t"
  )) var rejectTag: String = ""

  @Option(help: ArgumentHelp(
    "Output format <f>. Available: json or markdown ",
    valueName: "f"
  )) var format: EventFormat = .json

  @Option(help: ArgumentHelp(
    "Verbosity <v>. Available: quiet or normal ",
    valueName: "v"
  )) var verbosity: Verbosity = .quiet

  mutating func run() {
    Log.verbosity = verbosity

    let events = Service().next(
      within: within,
      ignoreAllDayEvents: ignoreAllDayEvents,
      ignorePatternTitle: ignorePatternTitle,
      rejectTag: rejectTag
    )
    switch format {
    case .json:
      events.printAsJson()
    case .markdown:
      events.printAsMarkdown()
    }
  }
}
