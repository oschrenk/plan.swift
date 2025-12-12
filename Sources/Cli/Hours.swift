import ArgumentParser
import Foundation
import when

/// `plan hours "..."`
///
/// List spent/planned hours
struct Hours: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List hours per event on ..."
  )

  @OptionGroup
  var calendar: CalendarOptions

  @OptionGroup
  var eventOptions: EventOptions

  @OptionGroup
  var general: Options

  @Argument(help: "Date expression eg. \"2025-04-03\" or \"last tuesday\"")
  var expression: String

  mutating func run() throws {
    var userDate: Date
    if let date = DateArgument.parse(s: expression) {
      userDate = date
    } else {
      // try natural date parsing
      StdErr.print("Can't parse date")
      throw ExitCode.failure
    }

    var cal = FCalendar.current
    cal.timeZone = TimeZone.current
    let today = cal.startOfDay(for: userDate)
    let start = cal.date(byAdding: .day, value: 0, to: today)!
    let end = cal.date(byAdding: .day, value: 1, to: today)!

    let opts = AllOptions(calendar: calendar, events: eventOptions, general: general)

    let orders = general.sortBy.isEmpty ? [Order.Default] : general.sortBy

    let eventSelector = EventSelector.Combined(selectors: [
      // first sort
      EventSelector.Sorted(orders: orders),
      // then choose all
      EventSelector.All(),
    ]
    )

    let events = Plan().events(
      start: start, end: end, opts: opts,
      selector: eventSelector,
      transformer: EventTransformer(rules: Loader.readConfig()?.iconize ?? [])
    )
    let groups = Dictionary(grouping: events, by: { $0.title.full })
      .mapValues { $0.reduce(into: 0) { $0 += $1.schedule.duration } }
      .mapValues { String(format: "%.2f", Double($0) / 60) }
    for group in groups {
      StdOut.print(group.key + ": " + group.value)
    }
  }
}
