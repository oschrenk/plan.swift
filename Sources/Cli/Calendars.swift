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
