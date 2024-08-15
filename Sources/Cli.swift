import ArgumentParser
import Foundation

@main
struct Cli: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Control Plan",
    subcommands: [
      Today.self,
      Next.self,
      Calendars.self,
    ]
  )

  mutating func run() {}
}

/// `plan today`
///
/// List today's events
struct Today: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List todays schedule"
  )

  @Option(help: ArgumentHelp(
    "Reject events which notes contain the tag <t> eg. 'timeblock' ",
    discussion: "Events with tag will be ignored",
    valueName: "t"
  )) var rejectTag: String = ""

  @Option(help: ArgumentHelp(
    "Output format <f>. Available: json or markdown ",
    discussion: "Output format",
    valueName: "f"
  )) var format: Format = .json

  @Option(help: ArgumentHelp(
    "Verbosity <v>. Available: quiet or normal ",
    discussion: "Verbosity level",
    valueName: "v"
  )) var verbosity: Verbosity = .quiet

  mutating func run() {
    Log.verbosity = verbosity

    let events = Plan().today(rejectTag: rejectTag)
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

    Plan().calendars().printAsJson()
  }
}

/// `plan next`
///
/// List next event(s)
struct Next: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List next event(s)"
  )

  @Option(help: ArgumentHelp(
    "Fetch events within <m> minutes.",
    discussion: "Only fetch events that already started or start within <m> minutes.",
    valueName: "m"
  )) var within: Int = 60

  @Flag(help: "Ignore") var ignoreAllDayEvents: Bool = false

  @Option(help: ArgumentHelp(
    "Ignore titles matching the given pattern <p>",
    discussion: "Titles matching the given regex pattern will be ignored",
    valueName: "p"
  )) var ignorePatternTitle: String = ""

  @Option(help: ArgumentHelp(
    "Reject events which notes contain the tag <t> eg. 'timeblock' ",
    discussion: "Events with tag will be ignored",
    valueName: "t"
  )) var rejectTag: String = ""

  @Option(help: ArgumentHelp(
    "Output format <f>. Available: json or markdown ",
    discussion: "Output format",
    valueName: "f"
  )) var format: Format = .json

  @Option(help: ArgumentHelp(
    "Verbosity <v>. Available: quiet or normal ",
    discussion: "Verbosity level",
    valueName: "v"
  )) var verbosity: Verbosity = .quiet

  mutating func run() {
    Log.verbosity = verbosity

    let events = Plan().next(
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
