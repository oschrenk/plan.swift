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
    "Outpt format <f>. Available: json or markdown ",
    discussion: "Output format",
    valueName: "f"
  )) var format: Format = .json

  mutating func run() {
    let events = Plan().today(rejectTag: rejectTag)
    switch format {
    case .json:
      events.printAsMarkdown()
    case .markdown:
      events.printAsJson()
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

  mutating func run() {
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

  mutating func run() {
    Plan().next(
      within: within,
      ignoreAllDayEvents: ignoreAllDayEvents,
      ignorePatternTitle: ignorePatternTitle,
      rejectTag: rejectTag
    ).printAsJson()
  }
}
