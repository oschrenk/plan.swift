import ArgumentParser
import Foundation

typealias FCalendar = Foundation.Calendar

/// `plan next`
///
/// List next event(s)
struct Next: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List next event(s)"
  )

  @OptionGroup
  var opts: SharedOptions

  @Option(help: ArgumentHelp(
    "Fetch events within <m> minutes",
    valueName: "m"
  )) var within: Int = 60

  mutating func run() {
    let today = Date()
    let start = FCalendar.current.date(byAdding: .day, value: 0, to: today)!
    let end = FCalendar.current.date(byAdding: .minute, value: within, to: today)!
    let eventSelector = EventSelector.prefix(count: 1)

    Main.run(start: start, end: end, opts: opts, eventSelector: eventSelector)
  }
}
