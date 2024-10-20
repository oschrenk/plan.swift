import EventKit
import Foundation

enum Main {
  static func run(
    start: Date,
    end: Date,
    opts: SharedOptions,
    eventSelector: ([EKEvent]) -> [EKEvent]
  ) {
    Log.setDebug(opts.debug)

    let calendarFilter = CalendarFilter.build(
      selectCalendars: opts.selectCalendars,
      ignoreCalendars: opts.ignoreCalendars,
      selectCalendarTypes: opts.selectCalendarTypes,
      ignoreCalendarTypes: opts.ignoreCalendarTypes
    )
    let eventFilter = EventFilter.build(
      ignoreAllDay: opts.ignoreAllDayEvents,
      ignorePatternTitle: opts.ignorePatternTitle,
      ignoreTags: opts.ignoreTags,
      minNumAttendees: opts.minNumAttendees,
      maxNumAttendees: opts.maxNumAttendees
    )

    let events = EventStore().fetch(
      start: start,
      end: end,
      calendarFilter: calendarFilter,
      eventFilter: eventFilter,
      eventSelector: eventSelector
    ).sorted { $0.schedule.end.inMinutes > $1.schedule.end.inMinutes }

    if opts.templatePath.isEmpty {
      events.printAsJson()
    } else {
      if let render = Template.render(path: opts.templatePath, events: events) {
        StdOut.print(render)
      } else {
        StdErr.print("Failed to render template at `\(opts.templatePath)`")
      }
    }
  }
}
