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

  @OptionGroup
  var opts: CalendarOptions

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

    let calendars = EventService(repo: EventRepo())
      .calendars(filter: CalendarFilter.build(
        opts: opts
      ))

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
