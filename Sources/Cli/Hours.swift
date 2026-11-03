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
    var cal = FCalendar.current
    cal.timeZone = TimeZone.current

    guard let userDate = DateArgument.parse(s: expression) else {
      StdErr.print("Can't parse date")
      throw ExitCode.failure
    }
    let period = cal.dateInterval(of: .day, for: userDate)!

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
      start: period.start, end: period.end, opts: opts,
      selector: eventSelector,
      transformer: EventTransformer(rules: Loader.readConfig()?.iconize ?? [])
    )

    let report = HoursReport.build(events: events, period: period, calendar: cal)
    StdOut.print(report.renderAsText())
  }
}
