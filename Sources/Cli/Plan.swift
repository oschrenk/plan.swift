import EventKit
import Foundation

class Plan {
  func events(
    start: Date,
    end: Date,
    opts: AllOptions,
    selector: EventSelectorI,
    transformer: EventTransformer
  ) -> [Event] {
    Log.setDebug(opts.general.debug)

    let calendarFilter = CalendarFilter.build(
      opts: opts.calendar
    )
    let eventFilter = EventFilter.build(
      ignoreAllDay: opts.events.ignoreAllDayEvents,
      selectAllDay: opts.events.selectAllDayEvents,
      ignorePatternTitle: opts.events.ignorePatternTitle,
      selectPatternTitle: opts.events.selectPatternTitle,
      ignoreTags: opts.events.ignoreTags,
      selectTags: opts.events.selectTags,
      minNumAttendees: opts.events.minNumAttendees,
      maxNumAttendees: opts.events.maxNumAttendees,
      minDuration: opts.events.minDuration,
      maxDuration: opts.events.maxDuration
    )

    let service = EventService(repo: EventRepo())

    let unsortedEvents = service.fetch(
      start: start,
      end: end,
      calendarFilter: calendarFilter,
      eventFilter: eventFilter
    )

    return selector
      .select(events: unsortedEvents)
      .map { transformer.transform(event: $0) }
  }
}
