import ArgumentParser
import Foundation
import when

typealias DateParser = when.Parser

/// `plan on "..."`
///
/// List any days events
struct On: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List events on ..."
  )

  @OptionGroup
  var calendar: CalendarOptions

  @OptionGroup
  var general: Options

  @OptionGroup
  var eventOptions: EventOptions

  @Argument(help: "Date expression")
  var expression: String

  mutating func run() throws {
    let parser = DateParser(rules: EN.all + Common.all)
    var userDate: Date
    do {
      let result = try parser.parse(text: expression, base: Date())
      userDate = result.date
    } catch {
      StdErr.print("Can't parse date")
      throw ExitCode.failure
    }

    let today = FCalendar.current.startOfDay(for: userDate)
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
