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
      selectCalendarIds: opts.calendar.selectCalendarIds,
      ignoreCalendarIds: opts.calendar.ignoreCalendarIds,
      selectCalendarSources: opts.calendar.selectCalendarSources,
      ignoreCalendarSources: opts.calendar.ignoreCalendarSources,
      selectCalendarTypes: opts.calendar.selectCalendarTypes,
      ignoreCalendarTypes: opts.calendar.ignoreCalendarTypes
    )
    let eventFilter = EventFilter.build(
      ignoreAllDay: opts.general.ignoreAllDayEvents,
      selectAllDay: opts.general.selectAllDayEvents,
      ignorePatternTitle: opts.general.ignorePatternTitle,
      selectPatternTitle: opts.general.selectPatternTitle,
      ignoreTags: opts.general.ignoreTags,
      selectTags: opts.general.selectTags,
      minNumAttendees: opts.general.minNumAttendees,
      maxNumAttendees: opts.general.maxNumAttendees,
      minDuration: opts.general.minDuration,
      maxDuration: opts.general.maxDuration
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
