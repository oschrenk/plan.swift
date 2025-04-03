import ArgumentParser
import Foundation

/// `plan today`
///
/// List today's events
struct Today: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List today's events"
  )

  @OptionGroup
  var calendar: CalendarOptions

  @OptionGroup
  var eventOptions: EventOptions

  @OptionGroup
  var general: Options

  mutating func run() {
    let today = FCalendar.current.startOfDay(for: Date())
    let start = FCalendar.current.date(byAdding: .day, value: 0, to: today)!
    let end = FCalendar.current.date(byAdding: .day, value: 1, to: today)!

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

    Printer().print(events: events, templatePath: general.templatePath)
  }
}
