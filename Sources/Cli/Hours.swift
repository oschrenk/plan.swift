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

  @Option(help: ArgumentHelp(
    "List the week <n> weeks before the current week",
    valueName: "n"
  )) var weeksAgo: Int?

  @Flag(help: ArgumentHelp(
    "Print as JSON"
  ))
  var json: Bool = false

  @Argument(help: ArgumentHelp(
    "Date expression eg. \"2025-04-03\" or \"last tuesday\". " +
      "Defaults to the current week"
  ))
  var expression: String?

  func validate() throws {
    if expression != nil, weeksAgo != nil {
      throw ValidationError("Use either a date expression or --weeks-ago")
    }
    if let weeksAgo, weeksAgo < 0 {
      throw ValidationError("--weeks-ago must not be negative")
    }
  }

  static func week(weeksAgo: Int, now: Date, calendar: FCalendar) -> DateInterval {
    let dayInWeek = calendar.date(byAdding: .weekOfYear, value: -weeksAgo, to: now)!
    return calendar.dateInterval(of: .weekOfYear, for: dayInWeek)!
  }

  mutating func run() throws {
    var cal = FCalendar.current
    cal.timeZone = TimeZone.current

    let period: DateInterval
    if let expression {
      guard let userDate = DateArgument.parse(s: expression) else {
        StdErr.print("Can't parse date")
        throw ExitCode.failure
      }
      period = cal.dateInterval(of: .day, for: userDate)!
    } else {
      period = Self.week(weeksAgo: weeksAgo ?? 0, now: Date(), calendar: cal)
    }

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
    if json {
      guard let render = report.renderAsJson() else {
        throw ExitCode.failure
      }
      StdOut.print(render)
    } else {
      StdOut.print(report.renderAsText())
    }
  }
}
