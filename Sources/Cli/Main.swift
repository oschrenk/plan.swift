import EventKit
import Foundation

enum Main {
  static func run(
    start: Date,
    end: Date,
    opts: SharedOptions,
    selector: EventSelectorI,
    transformer: EventTransformer
  ) {
    Log.setDebug(opts.debug)

    let calendarFilter = CalendarFilter.build(
      selectCalendars: opts.selectCalendars,
      ignoreCalendars: opts.ignoreCalendars,
      selectCalendarSources: opts.selectCalendarSources,
      ignoreCalendarSources: opts.ignoreCalendarSources,
      selectCalendarTypes: opts.selectCalendarTypes,
      ignoreCalendarTypes: opts.ignoreCalendarTypes
    )
    let eventFilter = EventFilter.build(
      ignoreAllDay: opts.ignoreAllDayEvents,
      selectAllDay: opts.selectAllDayEvents,
      ignorePatternTitle: opts.ignorePatternTitle,
      selectPatternTitle: opts.selectPatternTitle,
      ignoreTags: opts.ignoreTags,
      selectTags: opts.selectTags,
      minNumAttendees: opts.minNumAttendees,
      maxNumAttendees: opts.maxNumAttendees,
      minDuration: opts.minDuration,
      maxDuration: opts.maxDuration
    )

    let service = EventService(repo: EventRepo())

    let unsortedEvents = service.fetch(
      start: start,
      end: end,
      calendarFilter: calendarFilter,
      eventFilter: eventFilter
    )

    let events = selector
      .select(events: unsortedEvents)
      .map { transformer.transform(event: $0) }
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
