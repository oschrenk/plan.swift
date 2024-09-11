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
  var nextOpts: SharedOptions

  @Option(help: ArgumentHelp(
    "Fetch events within <m> minutes",
    valueName: "m"
  )) var within: Int = 60

  mutating func run() {
    Log.setDebug(nextOpts.debug)

    let calendarFilter = CalendarFilter.build(
      selectCalendars: nextOpts.selectCalendars,
      ignoreCalendars: nextOpts.ignoreCalendars,
      selectCalendarTypes: nextOpts.selectCalendarTypes,
      ignoreCalendarTypes: nextOpts.ignoreCalendarTypes
    )
    let eventFilter = EventFilter.build(
      ignoreAllDay: nextOpts.ignoreAllDayEvents,
      ignorePatternTitle: nextOpts.ignorePatternTitle,
      ignoreTags: nextOpts.ignoreTags,
      minNumAttendees: nextOpts.minNumAttendees,
      maxNumAttendees: nextOpts.maxNumAttendees
    )

    Log.write("next: About to call eventstore")

    let today = Date()
    let start = FCalendar.current.date(byAdding: .day, value: 0, to: today)!
    let end = FCalendar.current.date(byAdding: .minute, value: within, to: today)!
    let eventSelector = EventSelector.prefix(count: 1)

    let events = EventStore().fetch(
      start: start,
      end: end,
      calendarFilter: calendarFilter,
      eventFilter: eventFilter,
      eventSelector: eventSelector
    ).sorted { $0.schedule.end.inMinutes > $1.schedule.end.inMinutes }

    Log.write("next: Called eventstore")

    if nextOpts.templatePath.isEmpty {
      events.printAsJson()
    } else {
      if let render = Template.render(path: nextOpts.templatePath, events: events) {
        StdOut.print(render)
      } else {
        StdErr.print("Failed to render template at `\(nextOpts.templatePath)`")
      }
    }
  }
}
