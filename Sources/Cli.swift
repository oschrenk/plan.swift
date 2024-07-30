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

  mutating func run() {
    Plan().today().printAsJson()
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

  mutating func run() {
    Plan().next(
      within: within,
      ignoreAllDayEvents: ignoreAllDayEvents,
      ignorePatternTitle: ignorePatternTitle
    ).printAsJson()
  }
}
