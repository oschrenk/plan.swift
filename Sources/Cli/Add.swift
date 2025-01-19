import ArgumentParser
import EventKit
import Foundation

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
    if let addEvent = Parser.parse(text: lines[0]) {
      EventService(repo: EventRepo()).addEvent(event: addEvent)
    } else {
      StdErr.print("error parsing")
    }
  }
}
